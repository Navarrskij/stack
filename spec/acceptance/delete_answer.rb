require 'rails_helper'
 
  feature 'Delete answer', %q{
    In order to remove question
    As Author of question
    I want to delete the question
  } do 
 
  given(:author)   { create(:user) }
  given(:user2) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given(:answer)   { create(:answer, question: question, user: author) }
 
  scenario 'Author delete the answer' do
    sign_in(answer.user)
    visit question_path(answer.question)
    click_link 'Delete'
    expect(page).to have_content 'Answer is successfully deleted'
    expect(page).to_not have_content answer.body
  end
 
  scenario 'Non author delete the answer' do
    sign_in(user2)
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user delete the answer' do
    visit question_path(answer.question)
    expect(page).to_not have_link 'Delete'
  end
end