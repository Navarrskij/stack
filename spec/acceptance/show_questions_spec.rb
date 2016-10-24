require_relative 'acceptance_helper'

feature 'view question', %q{
  To find definite question
  As a user
  I want to see the list of questions
} do 
 
  scenario 'user can see list of questions' do

    question1 = create(:question)
    question2 = create(:question)
    visit questions_path

    expect(page).to have_content question1.title
    expect(page).to have_content question1.body
    expect(page).to have_content question2.title
    expect(page).to have_content question2.body
  end 
end
