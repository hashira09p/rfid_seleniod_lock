class User < ApplicationRecord
  has_many :cards, dependent: :destroy
  has_many :schedules, dependent: :destroy
  has_many :time_tracks, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: { admin: 0, professor: 1 }
  enum academic_college: { CIE: 0, COE: 1, CLA: 2, COS: 3, CAFA: 4, CIT: 5 }
  enum status: { inactive: 0, active: 1 }
end
