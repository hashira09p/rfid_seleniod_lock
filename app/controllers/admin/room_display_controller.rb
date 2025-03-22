class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!, except: [:room_statuses] # Allow public access to room_statuses

  def index
    @rooms = Room.all.includes(:schedules).order(:room_number)
    @room_statuses = fetch_room_statuses
  end

  def room_statuses
    render json: { "1": "time_in", "2": "time_out", "3": "vacant" }
  end

  private

  def fetch_room_statuses
    statuses = {}
    Room.includes(:time_tracks).each do |room|
      if room.room_status == "Unavailable"
        statuses[room.id] = "unavailable"
      else
        latest_time_track = room.time_tracks.order(created_at: :desc).first
        statuses[room.id] = latest_time_track&.status || "vacant"
      end
    end
    statuses
  end
end