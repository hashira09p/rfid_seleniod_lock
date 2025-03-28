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
    @active_rooms = Room.where(room_status: "Available").includes(:schedules)

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

  def calculate_available_time(schedules)
    full_day_range = (6 * 60..21 * 60).step(1).to_a # 6:00 AM to 9:00 PM in minutes
    booked_minutes = schedules.reject { |s| s.start_time == s.end_time } # Ignore zero-duration bookings
                              .map { |s| (s.start_time.hour * 60 + s.start_time.min..s.end_time.hour * 60 + s.end_time.min).to_a }
                              .flatten
                              .uniq

    available_minutes = full_day_range - booked_minutes
    return ["6:00 AM - 9:00 PM"] if available_minutes.size == full_day_range.size # Room is fully available

    format_available_slots(available_minutes)
  end

  def format_available_slots(available_minutes)
    return ["No Available Slots"] if available_minutes.empty?

    time_ranges = []
    start_time = available_minutes.first
    prev_time = start_time

    available_minutes.each_cons(2) do |curr, next_time|
      if next_time - curr > 1 # Found a gap between occupied times
        time_ranges << "#{format_time(start_time)} - #{format_time(prev_time + 1)}"
        start_time = next_time
      end
      prev_time = next_time
    end

    # Add the last available slot
    time_ranges << "#{format_time(start_time)} - #{format_time(prev_time + 1)}"
    time_ranges
  end

  def format_time(minutes)
    Time.new(2000, 1, 1, minutes / 60, minutes % 60).strftime('%I:%M %p')
  end

end
