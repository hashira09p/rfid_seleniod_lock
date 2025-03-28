class Admin::DashboardController < AdminApplicationController
  def index
    @total_users = User.count
    @active_users = User.where(status: 'active').count
    @inactive_users = User.where(status: 'inactive').count

    @total_cards = Card.count
    @active_cards = Card.where(status: "Active").count
    @inactive_cards = Card.where(status: "Inactive").count

    @total_rooms = Room.count
    @available_rooms = Room.where(room_status: 'Available').count
    @unavailable_rooms = Room.where(room_status: 'Unavailable').count

    room_status_counts = fetch_room_status_counts
    @vacant_rooms = room_status_counts[:vacant]
    @occupied_rooms = room_status_counts[:occupied]

    current_month = Date.today.month
    current_year = Date.today.year

    if current_month >= 7  # First Semester (July to December)
      @semester = "First Semester"
      @school_year = "#{current_year}-#{current_year + 1}"
    else  # Second Semester (January to June)
      @semester = "Second Semester"
      @school_year = "#{current_year - 1}-#{current_year}"
    end

    @total_schedules = Schedule.where(school_year: @school_year).count

    # Fetch only active rooms and their schedules
    @active_rooms = Room.where(room_status: "Available").includes(:schedules).order(room_number: :ASC)
    # Group schedules by room and day for easier rendering
    @room_schedules = Schedule
                        .joins(:user, :room)
                        .where(rooms: { room_status: "Available" }, school_year: @school_year)
                        .select("schedules.*, users.firstname, users.lastname, rooms.room_number")
                        .group_by(&:room_number)
  end

  private
  def fetch_room_status_counts
    available_rooms = Room.where(room_status: "Available").pluck(:id)
    unavailable_count = Room.where(room_status: "Unavailable").count

    occupied_rooms = TimeTrack.where(status: "time_in").distinct.pluck(:room_id)
    vacant_rooms = available_rooms - occupied_rooms

    {
      unavailable: unavailable_count,
      available: available_rooms.count,
      vacant: vacant_rooms.count,
      occupied: occupied_rooms.count
    }
  end
end
