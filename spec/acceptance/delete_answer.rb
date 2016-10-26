require_relative 'acceptance_helper'
 
  feature 'Delete answer', %q{
    In order to remove question
    As Author of question
    I want to delete the question
  } do 
 
  given(:author)   { create(:user) }
  given(:user2) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given(:answer)   { create(:answer, question: question, user: author) }
 
  scenario 'Author delete the answer', js: true do
    sign_in(author)
    visit question_path(answer.question)
    within '.answers' do
      click_on 'Delete'
      expect(page).to_not have_content answer.body
    end
  end
 
  scenario 'Non author delete the answer', js: true do
    sign_in(user2)
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user delete the answer',js: true do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete'
  end
end