class Admin::TimeTrackController < AdminApplicationController
  before_action :authenticate_admin_user!
  before_action :time_track_params, only: [:create, :update]
  before_action :set_time_track, only: [:edit, :update, :destroy]

  def index
    @time_tracks = TimeTrack.includes(:room, :user)

    # Apply filters only if any filter params are present
    filters_applied = params[:room_id].present? ||
      params[:name].present? ||
      params[:date].present? ||
      params[:time_in].present? ||
      params[:time_out].present? ||
      params[:status].present?

    # Filter by default to today's records if no filters are applied
    unless filters_applied
      @time_tracks = @time_tracks.where("DATE(created_at) = ?", Date.current)
    end

    # Apply filters
    if params[:room_number].present?
      @time_tracks = @time_tracks.joins(:room).where("rooms.room_number ILIKE ?", "%#{params[:room_number]}%")
    end

    if params[:name].present?
      @time_tracks = @time_tracks.joins(:user).where(
        "users.firstname ILIKE ? OR users.middlename ILIKE ? OR users.lastname ILIKE ?",
        "%#{params[:name]}%", "%#{params[:name]}%", "%#{params[:name]}%"
      )
    end

    if params[:date].present?
      @time_tracks = @time_tracks.where("DATE(created_at) = ?", params[:date])
    end

    if params[:time_in].present?
      @time_tracks = @time_tracks.where("time_in::time = ?", params[:time_in])
    end

    if params[:time_out].present?
      @time_tracks = @time_tracks.where("time_out::time = ?", params[:time_out])
    end

    @time_tracks = @time_tracks.where(status: params[:status]) if params[:status].present?

    # Sort by latest record
    @time_tracks = @time_tracks.order(created_at: :asc)
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
