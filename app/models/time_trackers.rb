class TimeTrackers < ApplicationRecord
  belongs_to :user

  enum status: { Not_late: 0, Late: 1 }
end