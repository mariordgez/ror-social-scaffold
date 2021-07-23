require 'rails_helper'

RSpec.describe 'User', type: :system do
  describe 'index page' do
    it 'shows the right content' do
      visit root_path
      expect(page).to have_content('Events')
    end
    it 'sends you to the sign in path' do
      visit root_path
      click_link('Sign In')
      expect(page).to have_content('Log in')
    end
  end
  describe 'the signin process', type: :feature do
    before :each do
      User.create(email: 'user@example.com', password: 'password')
      User.create(email: 'user2@example.com', password: 'password')
    end

    it 'signs me in' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      expect(page).to have_content 'Signed in successfully.'
    end
  end
  describe 'Create an event process', type: :feature do
    before :each do
      User.create(email: 'user@example.com', password: 'password')
      User.create(email: 'user2@example.com', password: 'password')
    end

    it 'sends you to create an event page' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'

      click_button 'Log in'
      click_link('New Event')
      expect(page).to have_content 'New Event'
    end
    it 'redirects to sign in page since you need to be signed in' do
      visit root_path
      click_link('New Event')
      expect(page).to have_content 'Log in'
    end
    it 'Successfully creates a new event' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('New Event')
      fill_in 'Title', with: 'user@example.com'
      fill_in 'Description', with: 'password'
      click_button 'Create Event'
      expect(page).to have_content 'Event was successfully created.'
    end
    it 'Successfully shows created event in user show page' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('New Event')
      fill_in 'Title', with: 'evento uno'
      fill_in 'Description', with: 'password'
      click_button 'Create Event'
      click_link('Back')
      click_link('User Events')
      expect(page).to have_content 'evento uno'
    end
    it 'Should not have the event displayed since another user is signed in' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('New Event')
      fill_in 'Title', with: 'evento uno'
      fill_in 'Description', with: 'password'
      click_button 'Create Event'
      click_link('Back')
      click_link('Sign Out')
      click_link('Sign In')
      fill_in 'Email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('User Events')
      expect(page).to_not have_content 'evento uno'
    end
    it 'Successfully creates a new attendee' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('New Event')
      fill_in 'Title', with: 'event user 1'
      fill_in 'Description', with: 'this is the event for user 1'
      click_button 'Create Event'
      click_link('Back')
      click_link('Sign Out')
      click_link('Sign In')
      fill_in 'Email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('Show')
      click_button 'Attend event'
      expect(page).to have_content 'Attende was successfully registered.'
    end
    it 'Shows attended events for the user' do
      visit root_path
      click_link('Sign In')
      fill_in 'Email', with: 'user@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('New Event')
      fill_in 'Title', with: 'event user 1'
      fill_in 'Description', with: 'this is the event for user 1'
      click_button 'Create Event'
      click_link('Back')
      click_link('Sign Out')
      click_link('Sign In')
      fill_in 'Email', with: 'user2@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'
      click_link('Show')
      click_button 'Attend event'
      click_link('Back')
      click_link('User Events')
      expect(page).to have_content 'event user 1'
    end
  end
end
