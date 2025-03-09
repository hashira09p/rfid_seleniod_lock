class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!

  def index
    @rooms = Room.all.includes(:schedules)
  end
end