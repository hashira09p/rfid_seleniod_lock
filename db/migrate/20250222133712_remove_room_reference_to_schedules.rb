class RemoveRoomReferenceToSchedules < ActiveRecord::Migration[7.0]
  def change
    remove_column :schedules, :room_id, :references
  end
end
