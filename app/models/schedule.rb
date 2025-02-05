class Schedule < ApplicationRecord
  belongs_to :user, optional: true

  enum description: { lab: 0, lecture: 1 }
  enum day: { Sunday: 0, Monday: 1, Tuesday: 2, Wednesday: 3, Thursday: 4, Friday: 5, Saturday: 6}

  validates :subject, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end