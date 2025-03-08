class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!

  def index
    current_time = Time.current
    current_day = current_time.wday
    formatted_time = current_time.strftime('%I:%M %p')

    @rooms = Room.all.includes(:schedules)

    @room_statuses = @rooms.map do |room|
      is_occupied = room.schedules.where(
        "day = ? AND start_time >= ? AND end_time <= ?",
        current_day, formatted_time, formatted_time
      ).exists?

      { room_number: room, status: is_occupied ? "Occupied" : "Available" }
    end
  end
end