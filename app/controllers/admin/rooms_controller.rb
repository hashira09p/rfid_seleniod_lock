class Admin::RoomsController < AdminApplicationController
  before_action :set_params, only: [:create, :update]

  def index
    @rooms = Room.all
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(set_params)

    if @room.save
      redirect_to rooms_path, notice: 'Room was successfully created.'
    else
      redirect_to new_room_path, alert: 'Room was failed to be created.'
    end
  end

  private

  def set_params
    params.require(:room).permit(:room_status, :room_number)
  end
end