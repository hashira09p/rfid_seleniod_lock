class Admin::SchedulesController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def index
    @days = Schedule.pluck(:day).uniq
    @users = User.pluck(:firstname, :middlename, :lastname, :id)
    @rooms = Room.pluck(:room_number, :id)

    @school_years = Schedule.distinct.pluck(:school_year).compact.sort

    @schedules = Schedule.includes(:user, :room)
                         .order(Arel.sql("day ASC, school_year ASC,
                                      TIME_FORMAT(start_time, '%p') DESC,
                                      TIME_FORMAT(start_time, '%h:%i %p') DESC"))

    # Apply filters if present
    @schedules = @schedules.where(day: params[:day]) if params[:day].present?
    @schedules = @schedules.where(user_id: params[:professor_id]) if params[:professor_id].present?
    @schedules = @schedules.where(room_id: params[:room_id]) if params[:room_id].present?
    @schedules = @schedules.where(school_year: params[:school_year]) if params[:school_year].present?
  end

  def new
    @schedule = Schedule.new
    @users = User.all
  end

  def create
    @schedule = Schedule.new(set_params)
    if @schedule.save
      redirect_to schedules_path, notice: 'Schedule was successfully created.'
    else
      redirect_to schedules_path, alert: 'Failed to create schedule.'
    end
  end

  def edit; end

  def update
    if @schedule.update(set_params)
      redirect_to schedules_path, notice: 'Schedule was successfully updated.'
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
end