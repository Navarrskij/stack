require_relative 'acceptance_helper'

feature 'Create comment for answer', %q{
  In order got get debate from community to answer
  As an authenticated user
  I want to be able to create comment for answer
} do 

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  
  scenario 'Authenticated user create comment', js: true do

    sign_in(user)

    visit question_path(question)
    within '.comment_answer' do
      click_link 'add Comment'
      fill_in 'Body', with: 'Comment 1 for answer'
      click_on 'Create Comment'
    end

    expect(page).to have_content 'Comment 1 for answer'
  end

  scenario 'Authenticated user create invalid comment', js: true do

    sign_in(user)

    visit question_path(question)
    within '.comment_answer' do
      click_on 'add Comment'
      click_on 'Create Comment'
    end

    expect(page).to have_content "Body can't be blank"
  end

    scenario 'Non-authenticated user create question', js: true do

    visit question_path(question)

    expect(page).to_not have_content 'add Coment'
  end
end