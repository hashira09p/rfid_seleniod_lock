class Admin::SchedulesController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def index
    if params[:encrypted_params].present?
      begin
        decrypted_params = Rack::Utils.parse_nested_query(EncryptionHelper.decrypt(params[:encrypted_params]))
        params.merge!(decrypted_params)
      rescue => e
        Rails.logger.error "Error decrypting parameters: #{e.message}"
        flash[:error] = "Invalid parameters."
        redirect_to schedules_path and return
      end
    end

    @days = Schedule.pluck(:day).uniq
    @users = User.all # Fetch all users as objects
    @rooms = Room.all # Fetch all rooms as objects
    @school_years = Schedule.distinct.pluck(:school_year).compact.sort

    # Build the base filtered query.
    filtered_schedules = Schedule.includes(:user, :room)
                                 .joins(:room)
                                 .order(Arel.sql("day ASC, school_year ASC, rooms.room_number ASC,
                                                TIME_FORMAT(start_time, '%p') DESC,
                                                TIME_FORMAT(start_time, '%h:%i %p') DESC"))

    # Apply filters if present.
    filtered_schedules = filtered_schedules.where(day: params[:day]) if params[:day].present?
    filtered_schedules = filtered_schedules.where(user_id: params[:professor_id]) if params[:professor_id].present?
    filtered_schedules = filtered_schedules.where(room_id: params[:room_id]) if params[:room_id].present?
    filtered_schedules = filtered_schedules.where(school_year: params[:school_year]) if params[:school_year].present?

    # For HTML, paginate the filtered query (e.g., 10 per page).
    @schedules = filtered_schedules.page(params[:page]).per(10)

    respond_to do |format|
      format.html  # renders index.html.erb using @schedules (paginated)
      format.pdf do
        pdf = SchedulePdf.new(filtered_schedules)  # full filtered set (no pagination)
        send_data pdf.render,
                  filename: "schedules.pdf",
                  type: "application/pdf",
                  disposition: "inline"
      end
    end
  end

  def new
    @schedule = Schedule.new
    @users = User.all
    @room_statuses = fetch_room_statuses
  end

  def create
    @schedule = Schedule.new(set_params)
    if @schedule.save
      redirect_to schedules_path, notice: 'Schedule was successfully created.'
    else
      redirect_to schedules_path, alert: 'Failed to create schedule.'
    end
  end

  def edit
    @room_statuses = fetch_room_statuses
  end

  def update
    if @schedule.update(set_params)
      redirect_to edit_schedule_path@schedule, notice: 'Schedule was successfully updated.'
    else
      redirect_to edit_schedule_path, alert: 'Failed to update schedule.'
    end
  end

  def destroy
    if @schedule.destroy
      redirect_to schedules_path, notice: 'Schedule was successfully deleted.'
    else
      redirect_to schedules_path, alert: 'Failed to delete schedule.'
    end
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def set_params
    params.require(:schedule).permit(:user_id, :description, :subject, :day, :start_time, :end_time, :room_id, :school_year)
  end

  def fetch_room_statuses
    statuses = {}
    Room.includes(:time_tracks).each do |room|
      statuses[room.id] = room.Unavailable? ? "unavailable" : "vacant"
    end
    statuses
  end
end