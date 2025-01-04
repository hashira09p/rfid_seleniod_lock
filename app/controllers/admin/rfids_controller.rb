class Admin::RfidsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index;end
  def create
    rfid_uid = params[:uid]

    card = Users.find_by(uid: rfid_uid)

    if card
      render json: { message: "Access granted", unlock: true }, status: :ok
    else
      render json: { message: "Access denied", unlock: false }, status: :unauthorized
    end
  end

  private

  def rfid_params
    params.require(:uid)
  end
end