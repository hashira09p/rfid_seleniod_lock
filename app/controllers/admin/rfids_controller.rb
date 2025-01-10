class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!, except: [:create]
  def index;end
  def create
    rfid_uid = params[:uid]
    room_status = params[:room_status]
    room_number = params[:room_number]
    card = Card.find_by(uid: rfid_uid)

    if card && room_status == "Lock"
      render json: { message: "Access granted", unlock: true }, status: :ok
    elsif card && room_status == "Unlock"
      render json: { message: "Access granted", lock: true }, status: :ok
    else
      render json: { message: "Access denied" }, status: :Unauthorized
    end

    # uid = params[:uid]
    # if uid.present?
    #   Rails.logger.info "Received UID: #{uid}"
    #   render json: { message: "UID received successfully", uid: uid }, status: :ok
    # else
    #   render json: { error: "UID is missing" }, status: :unprocessable_entity
    # end
  end

  private

  def authenticate_with_api_token
    api_token = request.headers['Authorization']
    head :unauthorized unless User.exists?(api_token: api_token)
  end
end