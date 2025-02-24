class AddRoomReferenceToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_reference :schedules, :room, null: false
  end
end
