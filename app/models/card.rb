class Card < ApplicationRecord
  enum status: { Inactive: 0, Active: 1 }
  enum uid_type: { card: 0, tag: 1 }
  enum remarks: { archived: 0, restored: 1 }

  belongs_to :user
  has_many :time_tracks, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :user_id, presence: true
  validates :uid_type, presence: true
end