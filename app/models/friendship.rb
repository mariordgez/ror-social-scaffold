class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  scope :confirmed_friend, -> { where(confirmed: true) }
  scope :unconfirmed_friend, -> { where(confirmed: false) }

  def confirm_friend
    update_attribute(:confirmed, true)
    Friendship.create!(
      friend_id: user_id,
      user_id: friend_id,
      confirmed: true
    )
  end
end
