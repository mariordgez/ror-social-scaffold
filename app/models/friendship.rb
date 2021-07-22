class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  scope :confirmed_friend, -> { where(confirmed: true) }
  scope :unconfirmed_friend, -> { where(confirmed: false) }
end
