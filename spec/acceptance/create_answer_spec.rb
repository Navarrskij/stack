require 'rails_helper'

feature 'Create answer', %q{
  To help community
  As an authenticated user
  I want to be able to answer the question
} do 

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  
  scenario 'Authenticated user create answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'bla bla bla'
    click_on 'Create Answer'
    
    expect(page).to have_content 'Answer successfully created'

  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Non-authenticated user can view the answer' do
    visit question_path(question)

    expect(current_path).to eq question_path(question)
  end
end