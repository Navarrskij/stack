require_relative 'acceptance_helper'

feature 'Edit answer', %q{
  In order to fix errors
  As an authenticated user
  I want to be able to edit my answer
} do 

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: user1) }
  given!(:answer) { create(:answer, question: question, user: user1) }

  scenario 'Authenticated user edit his answer', js: true do
    sign_in(user1)
    visit question_path(question)
    within '.answers' do
      click_link 'Edit'
      fill_in 'Body', with: 'edited answer'
      click_on 'Save'

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'edited answer'
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Non-authenticated user edit  answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  scenario 'Authenticated user edit other answer', js: true do
    sign_in(user2)
    visit question_path(question)
    
    expect(page).to_not have_link 'edit'
  end
    
  
end