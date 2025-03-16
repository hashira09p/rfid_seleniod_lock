class TimeTrack < ApplicationRecord
  belongs_to :user

  enum status: { time_in: 0, time_out: 1 }
end