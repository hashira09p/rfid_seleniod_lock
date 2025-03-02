class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!
  def index
    @room_numbers = Room.includes(:schedules)
  end
end