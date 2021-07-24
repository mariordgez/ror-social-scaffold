class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :confirmed_friendships,
           -> { where confirmed: true },
           class_name: 'Friendship'
  has_many :friends, through: :confirmed_friendships
  has_many :inverse_friendships,
           class_name: 'Friendship',
           foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  # Users who needs to confirm friendship
  has_many :pending_friendships,
           -> { where confirmed: false },
           class_name: 'Friendship',
           foreign_key: 'user_id'
  has_many :pending_friends, through: :pending_friendships, source: :friend

  # Users who requested to be friends (needed for notifications)
  has_many :inverted_friendships,
           -> { where confirmed: false },
           class_name: 'Friendship',
           foreign_key: 'friend_id'
  has_many :friend_requests, through: :inverted_friendships

  def all_friends
    friends_array =
      friendships.map do |friendship|
        friendship.friend_id if friendship.confirmed
      end
    friends_array +=
      inverse_friendships.map do |friendship|
        friendship.user_id if friendship.confirmed
      end
    friends_array.compact
  end
end
