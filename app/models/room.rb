class Room < ApplicationRecord
  has_many :schedules,  dependent: :destroy
  has_many :time_tracks, dependent: :destroy

  enum room_status: {Unavailable: 0, Available: 1}

  validates :room_number, presence: true, uniqueness: true
  validates :room_status, presence: true

  def update_room_status
    room.broadcast_status_update!

    # Also broadcast via RoomStatusChannel for JS DOM updates
    ActionCable.server.broadcast("RoomStatusChannel", [
      { room_id: room.id, status: room.current_status }
    ])
  end

  def current_status
    return "unavailable" if room_status == "Unavailable"

    latest_track = time_tracks.order(updated_at: :desc).first

    if latest_track.nil?
      Rails.logger.info "Room ##{id} → status: time_out (no record)"
      "time_out"
    elsif latest_track.time_out.present?
      Rails.logger.info "Room ##{id} → status: time_out (recorded time_out)"
      "time_out"
    else
      Rails.logger.info "Room ##{id} → status: time_in (ongoing)"
      "time_in"
    end
  end
end