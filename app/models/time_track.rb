class TimeTrack < ApplicationRecord
  belongs_to :user

  validates :created_at, uniqueness: { scope: :user_id }

  enum status: { Not_late: 0, Late: 1 }
end