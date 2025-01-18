class Admin::CardsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:handle_scan]
  def index
    @cards = Card.includes(:user)
  end

  def new
    @new_card
    puts @new_card
  end

  def create
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
end