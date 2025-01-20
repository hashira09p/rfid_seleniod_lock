class Card < ApplicationRecord
  enum status: { inactive: 0, active: 1 }
  enum uid_type: { card: 0, tag: 1 }

  belongs_to :user, optional: true

  validates :uid, presence: true, uniqueness: true
  validates :uid_type, presence: true
end
