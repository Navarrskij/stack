require 'rails_helper'

feature 'Create answer', %q{
  To help community
  As an authenticated user
  I want to be able to answer the question
} do 

  given(:user) {create(:user)}
  
  scenario 'Authenticated user create answer' do

    sign_in(user)

    visit questions_path
    click_on 'ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Save Question'

    expect(page).to have_content 'Question successfully created'
    click_on 'Save Question'
    visit questions_path
    click_on 'Answer'
    fill_in 'Body', with: 'bla bla bla'
    click_on 'Save Answer'

    expect(page).to have_content 'Answer successfully created'

  end

    scenario 'Non-authenticated user create answer' do

    visit questions_path
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User can view the answer' do

    visit questions_path

    expect(current_path).to eq questions_path
  end
end