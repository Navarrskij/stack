require 'rails_helper'

feature 'view question', %q{
  To find definite question
  As a user
  I want to see the list of questions
} do 
 
  scenario 'user can see list of questions' do

    question = create(:question)

    visit questions_path

    expect(page).to have_content question.title
  end 
end
