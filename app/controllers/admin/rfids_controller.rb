class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index; end

  def create
    rfid_uid    = params[:uid]
    room_status = params[:room_status]
    room_id     = params[:room_number]

    Rails.logger.info "🔔 RFID TAP RECEIVED → UID=#{rfid_uid}, ROOM=#{room_id}, STATUS=#{room_status}, AT=#{Time.current}"

    card = Card.find_by(uid: rfid_uid)
    return render json: { message: "Card not registered" }, status: :unauthorized unless card

    if card.status == "Inactive"
      return render json: { message: "Card inactive" }, status: :forbidden
    end

    ActiveRecord::Base.transaction do
      if room_status == "Lock"
        handle_lock(card, room_id)
      elsif room_status == "Unlock"
        handle_unlock(card, room_id)
      else
        render json: { message: "Invalid room status" }, status: :unprocessable_entity
      end
    end

  rescue StandardError => e
    logger.error "❌ RFID processing error: #{e.message}"
    render json: { message: "An unexpected error occurred" }, status: :internal_server_error
  end

  private

  def handle_lock(card, room_id)
    time_now = Time.current
    active_session = TimeTrack.find_by(card_id: card.id, room_id: room_id, time_out: nil)

    if active_session.nil?
      # No active session, proceed to time in
      TimeTrack.create!(
        card_id: card.id,
        user_id: card.user_id,
        room_id: room_id,
        time_in: time_now
      )

      render json: {
        message: "Access granted",
        unlock: true,
        user: card.user.firstname,
        time: time_now.strftime('%I:%M %p')
      }, status: :ok

    elsif active_session.card_id == card.id
      # 🔁 Recover from power loss — allow re-entry by completing the unlock step
      active_session.update!(time_out: time_now, status: 1)

      render json: {
        message: "Recovered session",
        lock: true,
        user: card.user.firstname,
        time: time_now.strftime('%I:%M %p')
      }, status: :ok

    else
      render json: {
        message: "Room already in use by another card",
        access: false
      }, status: :forbidden
    end
  end

  def handle_unlock(card, room_id)
    time_now = Time.current
    active_session = TimeTrack.find_by(card_id: card.id, room_id: room_id, time_out: nil)

    if active_session
      if active_session.card_id == card.id
        active_session.update!(time_out: time_now, status: 1)

        render json: {
          message: "Access granted",
          lock: true,
          user: card.user.firstname,
          time: time_now.strftime('%I:%M %p')
        }, status: :ok
      else
        render json: {
          message: "Access denied! Only the same card can time out.",
          access: false
        }, status: :forbidden
      end
    else
      render json: {
        message: "No active session to time out for this card",
        access: false
      }, status: :forbidden
    end
  end

  def authenticate_with_api_token
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    head :unauthorized unless token && User.exists?(api_token: token)
  end
end
