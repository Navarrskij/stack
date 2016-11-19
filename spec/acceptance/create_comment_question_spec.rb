require_relative 'acceptance_helper'

feature 'Create comment for question', %q{
  In order got get debate from community to question
  As an authenticated user
  I want to be able to create comment for question
} do 

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  scenario 'Authenticated user create comment', js: true do

    sign_in(user)

    visit question_path(question)
    click_on 'add Comment'
    within '.new_comment' do
      fill_in 'Body', with: 'Comment 1 for question'
      click_on 'Create Comment'
    end

    expect(page).to have_content 'Comment 1 for question'
  end

  scenario 'Authenticated user create invalid question', js: true do

    sign_in(user)

    visit question_path(question)
    click_on 'add Comment'
    click_on 'Create Comment'

    expect(page).to have_content "Body can't be blank"
  end

    scenario 'Non-authenticated user create question', js: true do

    visit question_path(question)

    expect(page).to_not have_content 'add Coment'
  end
end