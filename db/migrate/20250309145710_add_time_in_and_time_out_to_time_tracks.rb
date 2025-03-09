class AddTimeInAndTimeOutToTimeTracks < ActiveRecord::Migration[7.0]
  def change
    add_column :time_tracks, :time_in, :string, default: -> { "TIME_FORMAT(NOW(), '%I:%M %p')" }
    add_column :time_tracks, :time_out, :string, default: -> { "TIME_FORMAT(NOW(), '%I:%M %p')" }
  end
end
