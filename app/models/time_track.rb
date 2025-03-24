class TimeTrack < ApplicationRecord
  belongs_to :user
  belongs_to :room
  belongs_to :card

  enum status: { time_in: 0, time_out: 1 }
end