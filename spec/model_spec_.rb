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

RSpec.describe Event, type: :model do
  context 'User with a created event' do
    it 'Should be valid since all validations are true' do
      user = User.new(email: 'mario@gmail.com', password: '123456')
      event =
        user.events.new(
          title: 'first comment',
          description: 'first comment',
          date: Date.current,
        )
      expect(event).to be_valid
    end
    it 'Should not be valid because its missing title' do
      user = User.new(email: 'mario@gmail.com', password: '123456')
      event = user.events.new(description: 'first comment', date: Date.current)
      expect(event).to_not be_valid
    end
    it 'Should not be valid because its missing description' do
      user = User.new(email: 'mario@gmail.com', password: '123456')
      event = user.events.new(title: 'first comment', date: Date.current)
      expect(event).to_not be_valid
    end
    it 'Should not be valid because its missing date' do
      user = User.new(email: 'mario@gmail.com', password: '123456')
      event = user.events.new(description: 'first comment', title: 'title')
      expect(event).to_not be_valid
    end
  end
end
