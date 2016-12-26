require_relative 'acceptance_helper'

feature 'Search', %q{
  In order to find usefull information
  As User
  I'd like to be able to search questions, answers, comments and users
} do

  given!(:question1) { create(:question, title: 'The searchable question 1') }
  given!(:question2) { create(:question, title: 'The searchable question 2') }
  given!(:answer)   { create(:answer, body: 'The searchable answer') }
  given!(:comment1) { create(:comment, body: 'The searchable question comment') }
  given!(:comment2) { create(:answer_comment, body: 'The searchable answer comment') }
  given!(:user)     { create(:user, email: 'searchable@example.org') }
  
  given!(:question_other) { create(:question, title: 'The other question') }
  given!(:answer_other)   { create(:answer, body: 'The other answer') }
  given!(:comment_other)  { create(:comment, body: 'The other question comment') }
  given!(:user_other)     { create(:user, email: 'other@example.org') }

  background do
    index
    visit search_path
    fill_in 'query', with: 'searchable'
  end

  scenario 'User searches all', js: true do
    click_button 'Search'

      expect(page).to have_content question1.title
      expect(page).to have_content question2.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment1.body
      expect(page).to have_content user.email
  end

  scenario 'User searches questions', js: true do
    select 'Questions', from: 'context'
    click_button 'Search'

      expect(page).to have_content question1.title
      expect(page).to have_content question2.title
  end

  scenario 'User searches answers', js: true do
    select 'Answers', from: 'context'
    click_button 'Search'

      expect(page).to have_content answer.body
  end

  scenario 'User searches comments', js: true do
    select 'Comments', from: 'context'
    click_button 'Search'

      expect(page).to have_content comment1.body
      expect(page).to have_content comment2.body
  end

  scenario 'User searches users', js: true do
    select 'Users', from: 'context'
    click_button 'Search'

      expect(page).to have_content user.email
  end
end