class Card < ApplicationRecord
  enum status: { Inactive: 0, Active: 1 }
  enum uid_type: { card: 0, tag: 1 }

  belongs_to :user, optional: true
  has_many :time_tracks

  validates :uid, presence: true, uniqueness: true
  validates :uid_type, presence: true
end