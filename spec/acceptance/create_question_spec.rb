require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order got get answer from community
  I want to be able to ask qyestion
} do 

  given(:user) {create(:user)}
  
  scenario 'Authenticated user create question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create Question'

    expect(page).to have_content 'Test question'
    expect(page).to have_content 'text text text'
  end

  scenario 'Authenticated user create invalid question' do

    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Body', with: 'text text text'
    click_on 'Create Question'

    expect(page).to have_content '1 error prohibited from being saved:'
  end

  scenario 'Non-authenticated user create question' do

    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario "question appears on another user's page", js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end
 
    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask Question'
       fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Create Question'

      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    Capybara.using_session('guest') do
      
      expect(page).to have_content 'Test question'
    end
  end
end