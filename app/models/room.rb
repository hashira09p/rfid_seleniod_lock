class Room < ApplicationRecord
  has_many :schedules

  enum room_status: {Unavailable: 0, Available: 1}

  validates :room_number, presence: true, uniqueness: true
  validates :room_status, presence: true
end
