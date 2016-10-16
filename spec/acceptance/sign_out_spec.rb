require 'rails_helper'

feature 'User sign up', %q{
  So close to user session
  As an User
  I want to be able to log out
} do 

  given(:user) {create(:user)}
  
  scenario 'Authenticated user try to sign up' do

    sign_in(user)

    click_link 'Sign Out'

    expect(page).to have_content 'Signed out successfully.'
  end
end