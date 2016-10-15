require 'rails_helper'

feature 'User sing in', %q{
  In order to be able to ask question
  As an User
  I want to be able to sign in
} do 
  
  scenario 'Registered user try to sign in' do
    User.create!(email: '123@test.com', password: '1234567')

    visit new_user_session_path
    fill_in 'Email', with: '123@test.com'
    fill_in 'Password', with: '1234567'
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do

    visit new_user_session_path
    fill_in 'Email', with: '12345@test.com'
    fill_in 'Password', with: '01234567'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
    expect(current_path).to eq new_user_session_path
  end
end