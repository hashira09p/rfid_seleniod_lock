class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!

  def index
    @rooms = Room.all.includes(:schedules)

    @room_statuses = {}

    # Fetch the latest TimeTrack status for each room
    Room.all.each do |room|
      latest_time_track = TimeTrack.where(room_id: room.id).order(created_at: :desc).first
      @room_statuses[room.id] = latest_time_track&.status || "vacant" # Default to "vacant" if no record exists
    end
  end
end