class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index; end

  def create
    rfid_uid = params[:uid]
    card = Card.find_by(uid: rfid_uid)
    room_status = params[:room_status]
    room_id = params[:room_number]

    return render json: { message: "Card not registered" }, status: :unauthorized unless card

    if card.status == "Inactive"
      return render json: { message: "Card inactive" }, status: :forbidden
    end

    current_time = Time.current
    formatted_time = current_time.strftime('%I:%M %p')

    active_session = TimeTrack.where(card_id: card.id, room_id: room_id, time_out: nil).first

    if room_status == "Lock"
      if active_session.nil?
        TimeTrack.create(card_id: card.id, user_id: card.user_id, time_in: formatted_time, room_id: room_id)
        render json: { message: "Access granted", unlock: true, user: card.user.firstname }, status: :ok
      else
        render json: { message: "Room already in use by this card", access: false }, status: :forbidden
      end

    elsif room_status == "Unlock"
      if active_session
        if active_session.card_id == card.id
          active_session.update(time_out: formatted_time, status: 1)
          render json: { message: "Access granted", lock: true, user: card.user.firstname }, status: :ok
        else
          render json: { message: "Access denied! Only the same card can time out.", access: false }, status: :forbidden
        end
      else
        render json: { message: "No active session to time out for this card", access: false }, status: :forbidden
      end

    else
      render json: { message: "Invalid room status" }, status: :unprocessable_entity
    end

  rescue StandardError => e
    logger.error "Error processing RFID: #{e.message}"
    render json: { message: "An unexpected error occurred" }, status: :internal_server_error
  end

  private

  def authenticate_with_api_token
    auth_header = request.headers['Authorization']
    token = auth_header&.split(' ')&.last
    head :unauthorized unless token && User.exists?(api_token: token)
  end
end