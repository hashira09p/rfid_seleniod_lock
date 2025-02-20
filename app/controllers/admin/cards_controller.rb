class Admin::CardsController < AdminApplicationController
  skip_before_action :verify_authenticity_token, only: [:card_scan]
  before_action :set_params, only: [:create, :update]
  before_action :set_card, only: [:edit, :destroy, :update, :destroy]

  def index
    @cards = Card.includes(:user).order('users.firstname ASC, cards.created_at ASC')

    # filtering
    @cards = @cards.where(cards: { uid: params[:uid] }) if params[:uid].present?
    @cards = @cards.where(status: params[:status]) if params[:status].present?
    if params[:fullname].present?
      search_query = params[:fullname].strip.downcase

      @cards = @cards.joins(:user).where(
        'LOWER(users.firstname) LIKE :query OR LOWER(users.middlename) LIKE :query OR LOWER(users.lastname) LIKE :query OR ' \
          'LOWER(CONCAT(users.firstname, " ", users.middlename, " ", users.lastname)) LIKE :query OR ' \
          'LOWER(CONCAT(users.firstname, " ", users.lastname)) LIKE :query',
        query: "%#{search_query}%"
      )
    end
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(set_params)
    # The datetime here is optional, not tested yet. Rails automatically handles timestamps but if not, uncomment below.
    #@card.created_at = DateTime.now

    # if params[:card][:user_id].present?
    #   @card.user_id = params[:card][:user_id].to_i
    # end

    if @card.save
      flash[:notice] = "Card successfully created."
      redirect_to cards_path
    else
      flash[:alert] = "Error creating card."
      redirect_to new_card_path
    end
  end

  def edit; end

  def update
    if @card.update(set_params)
      flash[:notice] = "Card successfully updated."
      redirect_to cards_path
    else
      flash[:alert] = "Error updating card."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @card.destroy
      flash[:notice] = 'Card successfully deleted.'
    else
      flash[:alert] = @card.errors.full_messages.to_sentence
    end
    redirect_to cards_path
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
    params.require(:card).permit(:uid, :user_id, :status, :uid_type)
  end

  def set_card
    @card = Card.find(params[:id])
  end
end