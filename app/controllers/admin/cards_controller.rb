class Admin::CardsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:handle_scan]
  before_action :authenticate_admin_user!, except: :handle_scan
  def index
    @cards = Card.includes(:user)
  end

  def new
    @new_card
    puts @new_card
  end

  def create;end

  def handle_scan
    scanned_card_id = params[:rfid_uid] # Replace with the correct parameter key

    # Process the RFID card (e.g., validate it, etc.)
    # Then broadcast the UID to the RfidScanChannel
    ActionCable.server.broadcast("rfid_scans", { action: "display_uid", uid: scanned_card_id })

    render json: { success: true }
  end
end