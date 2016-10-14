require 'rails_helper'

feature 'Create question', %q{
  In order got get answer from community
  I want to be able to ask qyestion
} do 
  
  scenario 'User create question' do

    visit questions_path
    click_on 'ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    click_on 'Save Question'

    expect(page).to have_content 'Question successfully created'
  end

  scenario 'User can view the questions' do

    visit questions_path

    expect(current_path).to eq questions_path
  end
end