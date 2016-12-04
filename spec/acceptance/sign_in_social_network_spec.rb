require_relative 'acceptance_helper'

feature 'User sign in account', %q{
  In order to ask question and get answer from community
  As a user
  I want to sign on site with social network
} do

  scenario "Sign in with Facebook" do
  	visit new_user_session_path
    mock_auth_facebook
    click_on "Sign in with Facebook"

    expect(page).to have_content "new@new.com"
  end

  scenario "Sign in with Twitter" do
  	visit new_user_session_path
    mock_auth_twitter
    click_on "Sign in with Twitter"

    expect(page).to have_content "new@new.com"
  end

  scenario "Invalid Facebook account" do
  	visit new_user_session_path
    mock_auth_facebook_invalid
    click_on "Sign in with Facebook"

    expect(page).to have_content 'Authentication failed. Try again or register'
  end

  scenario "Invalid Twitter account" do
  	visit new_user_session_path
    mock_auth_twitter_invalid
    click_on "Sign in with Twitter"

    expect(page).to have_content 'Authentication failed. Try again or register'
  end
end