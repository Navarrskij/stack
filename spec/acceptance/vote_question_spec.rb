require_relative 'acceptance_helper'

feature 'Vote question', %q{
  In order to make a rating the question
  As Authenticated User
  I want to add a vote
} do
  
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:my_question) { create(:question, user: user) }

  scenario 'User votes vote_up', js: true do
    sign_in(user)
    visit question_path(question)

    
    Capybara.page.find('.glyphicon.glyphicon-thumbs-up').click
    within '.value' do
      expect(page).to have_content '1'
    end
  end

  scenario 'User votes vote_down', js: true do
    sign_in(user)
    visit question_path(question)

    Capybara.page.find('.glyphicon.glyphicon-thumbs-down').click

    within '.value' do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Non-authenticated user votes', js: true do
    visit question_path(question)
    
    expect(page).to_not have_selector('glyphicon.glyphicon-thumbs-down')
    expect(page).to_not have_selector('glyphicon.glyphicon-thumbs-up')
  end

  scenario 'User can not vote twice', js: true do
    sign_in(user)
    visit question_path(question)

    Capybara.page.find('.glyphicon.glyphicon-thumbs-down').click
    within '.value' do
      expect(page).to have_content '1'
    end

    Capybara.page.find('.glyphicon.glyphicon-thumbs-down').click

    within '.value' do
      expect(page).to have_content '1'
    end
  end

  scenario 'User can revoke', js: true do
    sign_in(user)
    visit question_path(question)

    Capybara.page.find('.glyphicon.glyphicon-thumbs-up').click

    within '.value' do
      expect(page).to have_content '1'
    end
    
    Capybara.page.find('.glyphicon.glyphicon-thumbs-down').click

    within '.value' do
      expect(page).to have_content '-1'
    end
  end

  scenario 'Author can not vote his question', js: true do
    sign_in(user)
    visit question_path(my_question)

    expect(page).to_not have_selector('glyphicon.glyphicon-thumbs-down')
    expect(page).to_not have_selector('glyphicon.glyphicon-thumbs-up')
  end
end