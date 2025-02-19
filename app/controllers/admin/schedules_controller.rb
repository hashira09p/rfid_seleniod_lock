class Admin::SchedulesController < AdminApplicationController
  before_action :set_params, only: [:create, :update]
  before_action :set_schedule, only: [:edit, :update, :destroy]

  def index
    @schedules = Schedule.includes(:user).all
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
    params.require(:schedule).permit(:user_id, :description, :subject, :day, :start_time, :end_time)
  end
end