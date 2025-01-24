class Schedule < ApplicationRecord
  belongs_to :user, optional: true

  enum description: { lab: 0, lecture: 1 }
  enum day: { sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

  validates :subject, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end