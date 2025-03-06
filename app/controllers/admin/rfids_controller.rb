class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index; end

  def create
    rfid_uid = params[:uid]
    card = Card.find_by(uid: rfid_uid)


    if card && room_status == "Lock"
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