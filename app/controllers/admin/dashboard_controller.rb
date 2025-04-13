class Admin::DashboardController < AdminApplicationController
  def index
    @total_users = User.count
    @active_users = User.where(status: 0).count
    @inactive_users = User.where(status: 1).count

    @total_cards = Card.count
    @active_cards = Card.where(status: 0).count
    @inactive_cards = Card.where(status: 1).count

    @total_rooms = Room.count
    @available_rooms = Room.where(room_status: 1).count
    @unavailable_rooms = Room.where(room_status: 0).count

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

    @recent_time_tracks = TimeTrack.includes(:user, :room, :card)
                                   .order(created_at: :desc)
                                   .page(params[:time_track_page])
                                   .per(5)

    today_day_number = Date.today.wday
    day_mapping = { 0 => 6, 1 => 0, 2 => 1, 3 => 2, 4 => 3, 5 => 4, 6 => 5 }
    today_system_day = day_mapping[today_day_number]

    @todays_schedules = Schedule.includes(:user)
                                .where(day: today_system_day, school_year: @school_year)
                                .order(:start_time)
                                .page(params[:schedule_page])
                                .per(5)

    @active_rooms = Room.where(room_status: 1).includes(:schedules).order(room_number: :asc)
    @day_names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    @room_schedules = {}
    Room.where(room_status: 1).each do |room|
      schedules = Schedule.includes(:user)
                          .where(room_id: room.id, school_year: @school_year)
                          .order(:start_time)

      next if schedules.empty?
      @room_schedules[room.room_number.to_s] = schedules
    end
  end

  private

  def fetch_room_status_counts
    available_rooms = Room.where(room_status: 1).pluck(:id)
    unavailable_count = Room.where(room_status: 0).count

    occupied_room_ids = TimeTrack.where(status: 0).distinct.pluck(:room_id).compact
    vacant_room_ids = available_rooms - occupied_room_ids

    {
      unavailable: unavailable_count,
      available: available_rooms.count,
      vacant: vacant_room_ids.count,
      occupied: occupied_room_ids.count
    }
  end
end