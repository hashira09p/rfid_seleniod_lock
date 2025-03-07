  class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index; end

  def create
    rfid_uid = params[:uid]
    card = Card.find_by(uid: rfid_uid)
    room_status = params[:room_status]

    day_integer = (DateTime.current.wday + 6) % 7
    current_time = Time.current
    current_day = current_time.wday
    formatted_time = current_time.strftime('%I:%M %p')

    user_schedule = Schedule.where("user_id = ? AND day =?", card.user_id, current_day)

    if card && room_status == "Lock"
      if user_schedule.day == day_integer && user_schedule.start_time >= formatted_time
        @time_track = TimeTracker.new(user_id: card.user_id, status: 0)
        @time_track.save
      elsif user_schedule.day == day_integer && user_schedule.start_time <= formatted_time
        @time_track = TimeTracker.new(user_id: card.user_id, status: 0)
        @time_track.save
      end
      render json: { message: "Access granted", unlock: true, user: card.user.firstname }, status: :ok
    elsif card && room_status == "Unlock"
      render json: { message: "Access granted", lock: true, user: card.user.firstname }, status: :ok
    else
      render json: { message: "Access denied" }, status: :Unauthorized
    end
  end

  private

  def authenticate_with_api_token
    api_token = request.headers['Authorization']
    head :unauthorized unless User.exists?(api_token: api_token)
  end
end