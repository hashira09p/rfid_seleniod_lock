class AddColumnToSchedules < ActiveRecord::Migration[7.0]
  def change
    add_column :schedules, :room, :integer
  end
end
