class Admin::CardsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:card_scan]
  before_action :set_params, only: [:create]
  def index
    @cards = Card.includes(:user)
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(set_params)
    if params[:card][:user_id].present?
      @card.user_id = params[:card][:user_id].to_i
    end

    if @card.save
      flash[:notice] = "Successfully created card."
      redirect_to cards_path
    else
      flash[:alert] = "Error creating card."
      redirect_to new_card_path
    end
  end

  def card_scan
    scanned_card_id = params[:uid] # Replace with the correct parameter key
    card = Card.find_by(uid: scanned_card_id)

    if card.present?
      ActionCable.server.broadcast("rfid_scans", { action: "display_uid", denied: "The card is already in use" })
      render json: { success: false }
    else
      ActionCable.server.broadcast("rfid_scans", { action: "display_uid", uid: scanned_card_id })
      render json: { success: true }
    end
  end

  private

  def set_params
    params.require(:card).permit(:uid, :status, :uid_type)
  end
end