require 'rails_helper'

feature 'User sign up', %q{
  So close to user session
  As an User
  I want to be able to log out
} do 
  
  scenario 'Authenticated user try to sign up' do
    User.create!(email: '123@test.com', password: '1234567')

    visit new_user_session_path
    fill_in 'Email', with: '123@test.com'
    fill_in 'Password', with: '1234567'
    click_on 'Log in'
    visit root_path
    #save_and_open_page
    click_on 'Sign out'
    #save_and_open_page
    expect(page).to have_content 'Signed out successfully.'
  end
end