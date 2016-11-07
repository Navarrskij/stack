require_relative 'acceptance_helper'

feature 'Vote question', %q{
  In order to make a rating the question
  As Authenticated User
  I want to add a vote
} do
  
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:my_question) { create(:question, user: user) }

  scenario 'User votes vote_up' do
    sign_in(user)
    visit question_path(question)

    click_on 'vote_up'
    
    expect(page).to have_content '1'
  end

  scenario 'User votes vote_down'
    sign_in(user)
    visit question_path(question)

    click_on 'vote_down'
    
    expect(page).to have_content '-1'
  end

  scenario 'Non-authenticated user votes'
    visit question_path(question)
    
    expect(page).to_not have_content 'vote_down'
    expect(page).to_not have_content 'vote_up'
  end
  
end