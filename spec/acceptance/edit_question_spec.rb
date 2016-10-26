require_relative 'acceptance_helper'

feature 'Edit question', %q{
  In order to fix errors
  As an authenticated user
  I want to be able to edit my question
} do 

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }

  scenario 'Authenticated user edit his question', js: true do
    sign_in(user1)
    visit question_path(question)
    within '.question' do
      click_link 'Edit'
      fill_in 'Body', with: 'mynewquestion'
      fill_in 'Title', with: 'mynewtitle'
      click_on 'Save question'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'mynewquestion'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Non-authenticated user edit question', js: true do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Authenticated user edit other question', js: true do
    sign_in(user2)
    visit question_path(question)
    
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end