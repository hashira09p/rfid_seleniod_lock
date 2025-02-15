class Admin::HomeController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:crate]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]
  def index
    @users = User.all
  end

  def create
    rfid_uid = params[:uid]
    puts rfid_uid
    card = Card.find_by(uid: rfid_uid)

    if card
      render json: { message: "Access granted", unlock: true }, status: :ok
    else
      render json: { message: "Access denied", unlock: false }, status: :unauthorized
    end
  end

  def authenticate_with_api_token
    api_token = request.headers['Authorization']
    head :unauthorized unless User.exists?(api_token: api_token)
  end
end