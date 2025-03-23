class Admin::TimeTrackController < AdminApplicationController
  before_action :authenticate_admin_user!
  before_action :time_track_params, only: [:create, :update]
  before_action :set_time_track, only: [:edit, :update, :destroy]

  def index
    # Fetch initial data
    @rooms = Room.pluck(:room_number).uniq
    @professors = User.pluck(:firstname, :middlename, :lastname, :id)
    @time_tracks = TimeTrack.includes(:room, :user)

    # Apply filters
    if params[:room_number].present?
      @time_tracks = @time_tracks.joins(:room).where("rooms.room_number = ?", params[:room_number])
    end

    if params[:professor_id].present?
      @time_tracks = @time_tracks.where(user_id: params[:professor_id])
    end

    if params[:status].present?
      @time_tracks = @time_tracks.where(status: params[:status])
    end

    # Date filtering logic
    if params[:start_date].present? && params[:end_date].present?
      # Filter by range when both dates are provided
      @time_tracks = @time_tracks.where("DATE(time_tracks.created_at) BETWEEN ? AND ?", params[:start_date], params[:end_date])
    elsif params[:start_date].present?
      # Filter by start date only (records from start_date onward)
      @time_tracks = @time_tracks.where("DATE(time_tracks.created_at) = ?", params[:start_date])
    elsif params[:end_date].present?
      # Filter by end date only (records on or before end_date)
      @time_tracks = @time_tracks.where("DATE(time_tracks.created_at) <= ?", params[:end_date])
    else
      # Default to today's records if no date filters are applied
      @time_tracks = @time_tracks.where("DATE(time_tracks.created_at) = ?", Date.current)
    end

    # Sort by room number and created_at
    @time_tracks = @time_tracks.joins(:room)
                               .order("rooms.room_number ASC, time_tracks.created_at ASC")
  end

  def edit
  end

  def update
    if @time_track.update(time_track_params)
      flash[:success] = "Time Track updated successfully."
      redirect_to time_track_index_path
    else
      flash[:error] = "Failed to update Time Track."
      render :edit
    end
  end

  def destroy
    if @time_track.destroy
      flash[:success] = "Time Track deleted successfully."
    else
      flash[:error] = "Failed to delete Time Track."
    end
    redirect_to time_track_index_path
  end

  private

  def set_time_track
    @time_track = TimeTrack.find(params[:id])
  end

  def time_track_params
    params.require(:time_track).permit(:user_id, :room_id, :time_in, :time_out, :status)
  end
end
