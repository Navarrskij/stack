require_relative 'acceptance_helper'
 
feature 'Delete questions files', %q{
  In order to remove questions files
   As an question author
   I want to be able to deleteattach file
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Question'
    click_on 'Show'
  end
 
  scenario "Author delete attach file", js: true do
    click_on 'del'

    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario "No Author delete attach file", js: true do
    click_on 'Sign Out'
    sign_in(user2)
    visit "/questions/1"

    expect(page).to_not have_link 'del'
  end
end 