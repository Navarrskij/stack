require 'rails_helper'

feature 'view answers and question', %q{
  To find more information
  As a user
  I want to see question and answers
} do 
 
  scenario 'user can see answers and question' do

    question = create(:question_answers)

    visit question_path question

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content "bodynew1"
    expect(page).to have_content "bodynew2"
    expect(page).to have_content "bodynew3"
  end 
end
