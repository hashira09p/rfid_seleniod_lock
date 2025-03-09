  class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index; end

  def create
    rfid_uid = params[:uid]
    card = Card.find_by(uid: rfid_uid)
    room_status = params[:room_status]

    return render json: { message: "Access denied" }, status: :unauthorized unless card

    current_time = Time.current
    formatted_time = current_time.strftime('%I:%M %p')

    first_active_user = TimeTrack.where(time_out: nil).order(created_at: :asc).first

    if room_status == "Lock"
      if first_active_user.nil?
        TimeTrack.create(user_id: card.user_id, time_in: formatted_time)

        render json: { message: "Access granted", unlock: true, user: card.user.firstname }, status: :ok
      else
        render json: { message: "Access granted", unlock: true, user: card.user.firstname }, status: :ok
      end

    elsif room_status == "Unlock"
      if first_active_user && first_active_user.user_id == card.user_id
        first_active_user.update(time_out: formatted_time, status: 1)

        render json: { message: "Access granted", lock: true, user: card.user.firstname }, status: :ok
      else
        render json: { message: "Access granted", lock: true, user: card.user.firstname }, status: :ok
      end
    else
      render json: { message: "Invalid room status" }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_with_api_token
    api_token = request.headers['Authorization']
    head :unauthorized unless User.exists?(api_token: api_token)
  end
end