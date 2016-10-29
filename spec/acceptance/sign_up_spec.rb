require_relative 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign up
} do 
  
  scenario 'Registered user' do
 
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: '123@test.com'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '1234567'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Invalid password confirmation ' do
 
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: '123@test.com'
    fill_in 'Password', with: '1234567'
    fill_in 'Password confirmation', with: '01234567'
    click_on 'Sign up'
    expect(page).to have_content 'error prohibited this user from being saved'
  end
end