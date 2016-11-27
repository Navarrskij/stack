require_relative 'acceptance_helper'

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

  scenario 'Authenticated user create invalid answer', js: true do
    sign_in(user)

    visit question_path(question)
    click_on 'Create Answer'
    
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user create answer' do
    visit question_path(question)
    click_on 'Create Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "amswer appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end
 
    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      fill_in 'Body', with: 'bla bla bla'
      click_on 'Create Answer'
    end

    Capybara.using_session('guest') do
      
      expect(page).to have_content 'bla bla bla'
    end
  end
end