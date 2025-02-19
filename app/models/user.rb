class User < ApplicationRecord
  has_many :cards
  has_many :schedules
  has_many :time_trackers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { admin: 0, professor: 1 }
  enum academic_college: { CIE: 0, COE: 1, CLA: 2, COS: 3, CAFA: 4, CIT: 5 }
end
