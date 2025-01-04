class Admin::RfidsController < AdminApplicationController
  before_action :authenticate_with_api_token
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_user!, except: [:create]
  def index;end
  def create
    rfid_uid = params[:uid]
    puts params[:room_number].to_i
    card = User.find_by(uid: rfid_uid)

    if card
      render json: { message: "Access granted", unlock: true }, status: :ok
    else
      render json: { message: "Access denied", unlock: false }, status: :unauthorized
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