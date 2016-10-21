require 'rails_helper'
 
feature 'Delete question', %q{
  In order to remove question
  As Author of question
  I want to delete the question 
} do 
 
  
  given(:author) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author delete the question' do
    sign_in(author)
    visit question_path(question)
    click_link 'Delete'
    expect(page).to have_content 'Question is successfully deleted'
    expect(page).to_not have_content question.body
  end
 
  scenario 'Non author delete the question' do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Non-authenticated user delete the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end 