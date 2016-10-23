require 'rails_helper'

feature 'Create answer', %q{
  To help community
  As an authenticated user
  I want to be able to answer the question
} do 

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  
  scenario 'Authenticated user create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'bla bla bla'
    click_on 'Create Answer'
    
    expect(page).to have_content 'bla bla bla'
  end

  scenario 'Authenticated user create invalid answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Create Answer'
    
    expect(page).to have_content '1 error prohibited from being saved:'
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end