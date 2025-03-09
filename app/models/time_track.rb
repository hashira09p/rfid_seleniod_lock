class TimeTrack < ApplicationRecord
  belongs_to :user

  validates :created_at, uniqueness: { scope: :user_id }

  enum status: { time_in: 0, time_out: 1 }
end