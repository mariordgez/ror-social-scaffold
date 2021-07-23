require 'rails_helper'

RSpec.describe 'User', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit root_path

      expect(page).to have_content('Sign up')
    end
  end
  describe 'the signin process', type: :feature do
    before :each do
      User.create(
        email: 'user1@example.com',
        password: 'password',
        name: 'user1',
      )

      User.create(
        email: 'user2@example.com',
        password: 'password',
        name: 'user2',
      )

      User.create(
        email: 'user3@example.com',
        password: 'password',
        name: 'user3',
      )
    end

    it 'signs me in' do
      visit user_session_path

      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end
  end
  describe 'Create an post process', type: :feature do
    before :each do
      User.create(
        email: 'user1@example.com',
        password: 'password',
        name: 'user1',
      )
      User.create(
        email: 'user2@example.com',
        password: 'password',
        name: 'user2',
      )
      User.create(
        email: 'user3@example.com',
        password: 'password',
        name: 'user3',
      )
    end

    it 'successfully creates a new post' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      expect(page).to have_content 'Post was successfully created.'
    end
    it 'redirects to sign in page since you need to be signed in' do
      visit user_session_path
      click_link('Timeline')
      expect(
        page,
      ).to have_content 'You need to sign in or sign up before continuing.'
    end

    it 'Should not have the event displayed since another user is signed in' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('Sign out')
      fill_in 'email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('My profile')

      expect(page).to_not have_content 'this is a new post'
    end
  end
  describe 'Create an a comment on a post', type: :feature do
    before :each do
      User.create(
        email: 'user1@example.com',
        password: 'password',
        name: 'user1',
      )
    end

    it 'successfully creates a new comment' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      fill_in 'comment_content', with: 'this is a comment'
      click_button 'Comment'
      expect(page).to have_content 'Comment was successfully created.'
    end
  end
  describe 'Create a like on a post', type: :feature do
    before :each do
      User.create(
        email: 'user1@example.com',
        password: 'password',
        name: 'user1',
      )
    end

    it 'successfully creates a new like' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('Like!')
      expect(page).to have_content 'Dislike!'
    end
  end
  describe 'Friendships', type: :feature do
    before :each do
      User.create(
        email: 'user1@example.com',
        password: 'password',
        name: 'user1',
      )
      User.create(
        email: 'user2@example.com',
        password: 'password',
        name: 'user2',
      )
      User.create(
        email: 'user3@example.com',
        password: 'password',
        name: 'user3',
      )
    end

    it 'successfully creates a new friend request' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('All users')
      first(:link, 'Add Friend').click
      expect(page).to have_content 'Friend request was successfully created.'
    end
    it 'successfully creates a new friend ' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('All users')
      first(:link, 'Add Friend').click
      click_link('Sign out')
      fill_in 'email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('My profile')

      click_link('Accept Request')

      expect(page).to have_content 'Friend request was successfully accepted.'
    end
    it 'Allows you to see your friends posts in timeline ' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('All users')
      first(:link, 'Add Friend').click
      click_link('Sign out')
      fill_in 'email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('My profile')
      click_link('Accept Request')
      click_link('Timeline')

      expect(page).to have_content 'this is a new post'
    end
    it 'Allows you to deny a request' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('All users')
      first(:link, 'Add Friend').click
      click_link('Sign out')
      fill_in 'email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('My profile')
      click_link('Deny Request')

      expect(page).to have_content 'Friend was successfully removed'
    end
    it 'Allows you to see your friends posts in timeline ' do
      visit user_session_path
      fill_in 'email', with: 'user1@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      fill_in 'Add New Post', with: 'this is a new post'
      click_button 'Save'
      click_link('All users')
      first(:link, 'Add Friend').click
      click_link('Sign out')
      fill_in 'email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('My profile')
      click_link('Accept Request')
      click_link('Remove Friend')

      expect(page).to have_content 'Friend was successfully removed'
    end
  end
end
