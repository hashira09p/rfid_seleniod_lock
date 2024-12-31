class Admin::RfidsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def index;end
  def create
    def create
      uid = params[:uid]
      if uid.present?
        Rails.logger.info "Received UID: #{uid}"
        render json: { message: "UID received successfully", uid: uid }, status: :ok
      else
        render json: { error: "UID is missing" }, status: :unprocessable_entity
      end
    end
  end

  private

  def rfid_params
    params.require(:uid)
  end
end