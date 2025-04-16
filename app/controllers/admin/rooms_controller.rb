class Admin::RoomsController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_room, only: [:edit, :update, :destroy]

  def index
    @rooms = Room.order(:room_number)

    # Filtering by room number
    @rooms = @rooms.where('room_number LIKE ?', "%#{params[:room_number].strip}%") if params[:room_number].present?
    @rooms = @rooms.where(room_status: params[:room_status]) if params[:room_status].present?
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(set_params)

    if @room.save
      redirect_to rooms_path, notice: 'Room was successfully created.'
    else
      redirect_to new_room_p ath, alert: 'Room was failed to be created.'
    end
  end

  def edit
  end

  def update
    if @room.update(set_params)
      redirect_to rooms_path, notice: 'Room was successfully updated.'
    else
      render :edit, alert: 'Room failed to be updated.'
    end
  end

  def destroy
    if @room.destroy
      redirect_to rooms_path, notice: 'Room was successfully deleted.'
    else
      redirect_to rooms_path, alert: 'Room failed to be deleted.'
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def set_params
    params.require(:room).permit(:room_status, :room_number)
  end
end