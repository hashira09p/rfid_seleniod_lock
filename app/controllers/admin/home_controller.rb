class Admin::HomeController < AdminApplicationController
  def index;end

  def create
    rfid_uid = params[:uid]
    puts rfid_uid
    card = User.find_by(uid: rfid_uid)

    if card
      render json: { message: "Access granted", unlock: true }, status: :ok
    else
      render json: { message: "Access denied", unlock: false }, status: :unauthorized
    end
  end
end