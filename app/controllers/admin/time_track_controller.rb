class Admin::TimeTrackController < AdminApplicationController
  before_action :authenticate_admin_user!
  before_action :time_track_params, only: [:create, :update]
  before_action :set_time_track, only: [:edit, :update, :destroy]

  def index
    @time_tracks = TimeTrack.includes(:room)
                            .where("DATE(created_at) = ?", Date.current)
                            .order(created_at: :desc)
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
