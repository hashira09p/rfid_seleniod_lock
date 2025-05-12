class Admin::RoomDisplayController < AdminApplicationController
  before_action :authenticate_admin_user!, except: [:room_statuses] # Allow public access to room_statuses

  def index
    @rooms = Room.all.includes(:schedules).order(:room_number)
    @room_statuses = fetch_room_statuses
  end

  def show
    @room = Room.find(params[:id])
    @schedules = @room.schedules.includes(:user).order(:start_time)
    @todays_schedules = @schedules.where(day: Date.today.wday) # Get schedules for today
    @available_slots = calculate_available_time(@todays_schedules)
    @today_time_tracks = @room.time_tracks
                              .where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
                              .order(time_in: :desc)
                              .page(params[:page])
                              .per(10)
  end

  def room_statuses
    rooms = Room.all.includes(:time_tracks)
    statuses = {}

    rooms.each do |room|
      statuses[room.id] = room.current_status
    end

    render json: statuses
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

  def calculate_available_time(schedules)
    full_day_range = (6 * 60..21 * 60).step(1).to_a # 6:00 AM to 9:00 PM in minutes
    booked_minutes = schedules.reject { |s| s.start_time == s.end_time } # Ignore zero-duration bookings
                              .map { |s| (s.start_time.hour * 60 + s.start_time.min..s.end_time.hour * 60 + s.end_time.min).to_a }
                              .flatten
                              .uniq

    available_minutes = full_day_range - booked_minutes
    format_available_slots(available_minutes)
  end

  def format_available_slots(available_minutes)
    return [] if available_minutes.empty?

    time_ranges = []
    start_time = available_minutes.first
    prev_time = start_time

    available_minutes.each_cons(2) do |curr, next_time|
      if next_time - curr > 1 # If there is a gap
        time_ranges << "#{format_time(start_time)} - #{format_time(prev_time)}"
        start_time = next_time
      end
      prev_time = next_time
    end

    time_ranges << "#{format_time(start_time)} - #{format_time(prev_time)}"
    time_ranges
  end

  def format_time(minutes)
    Time.new(2000, 1, 1, minutes / 60, minutes % 60).strftime('%I:%M %p')
  end
end