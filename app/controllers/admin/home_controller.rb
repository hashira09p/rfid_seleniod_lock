class Admin::HomeController < AdminApplicationController
  before_action :authenticate_with_api_token, only: [:crate]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :authenticate_admin_user!, except: [:create]

  def index
    @users = User.order(:firstname)

    # filtering
    if params[:fullname].present?
      search_query = params[:fullname].strip.downcase

      @users = @users.where(
        'LOWER(firstname) LIKE :query OR LOWER(middlename) LIKE :query OR LOWER(lastname) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", middlename, " ", lastname)) LIKE :query OR ' \
          'LOWER(CONCAT(firstname, " ", lastname)) LIKE :query',
        query: "%#{search_query}%"
      )
    end

    if params[:card_number].present?
      @users = @users.joins(:cards).where(cards: { uid: params[:card_number] })
    end
    @users = @users.where(academic_college: params[:academic_college]) if params[:academic_college].present?
    @users = @users.where(role: params[:role]) if params[:role].present?
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