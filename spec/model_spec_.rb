require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Creating a user' do
    it 'Should be valid since all validations are true' do
      user =
        User.new(
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      expect(user).to be_valid
    end
    it 'Should not be valid since its missing email' do
      user = User.new(password: '123456')
      expect(user).to_not be_valid
    end
    it 'Should not be valid since its missing password' do
      user = User.new(email: '123456')
      expect(user).to_not be_valid
    end
    it 'Should not be valid since password lenght < 6' do
      user = User.new(email: 'mario123456@gmail.com', password: '12345')
      expect(user).to_not be_valid
    end
    it 'Should not be valid it is missing name' do
      user = User.new(email: 'mario123456@gmail.com', password: '12345')
      expect(user).to_not be_valid
    end
  end
end

RSpec.describe Post, type: :model do
  context 'User with a created post' do
    it 'Should be valid since all validations are true' do
      user =
        User.new(
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      post = user.posts.new(content: 'this is a post')
      expect(post).to be_valid
    end
    it 'Should not be valid because its missing content' do
      user =
        User.new(
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      post = user.posts.new(content: '')
      expect(post).to_not be_valid
    end
  end
end

RSpec.describe Like, type: :model do
  context 'User likes a post' do
    it 'Should be valid since all validations are true' do
      user =
        User.new(
          id: 1,
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      post = user.posts.new(content: 'this is a post', id: 1)
      like = user.likes.new(user: user, post: post)
      expect(like).to be_valid
    end
    it 'Should not be valid since user can only like a post once' do
      user =
        User.create(
          id: 1,
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      post = user.posts.create(content: 'this is a post', id: 1)
      like = user.likes.create(user: user, post: post)
      like2 = user.likes.create(user: user, post: post)
      expect(like2).to_not be_valid
    end
  end
end

RSpec.describe Friendship, type: :model do
  context 'User creates a friendship' do
    it 'Should be valid since all validations are true' do
      user1 =
        User.create(
          id: 1,
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      user2 =
        User.create(
          id: 2,
          email: 'alberto123456@gmail.com',
          password: '123456',
          name: 'alberto',
        )
      friendship =
        user1.friendships.build(friend_id: user2.id, confirmed: false)
      expect(friendship).to be_valid
    end
    it 'Should validate inverse friendships' do
      user1 =
        User.create(
          id: 1,
          email: 'mario123456@gmail.com',
          password: '123456',
          name: 'mario',
        )
      user2 =
        User.create(
          id: 2,
          email: 'alberto123456@gmail.com',
          password: '123456',
          name: 'alberto',
        )
      friendship =
        user1.friendships.create(friend_id: user2.id, confirmed: false)
      inverse = user2.inverse_friendships.find_by(user_id: user1.id)
      expect(inverse.user_id).to eql(1)
    end
  end
end
