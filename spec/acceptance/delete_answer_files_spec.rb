require_relative 'acceptance_helper'
 
feature 'Delete answers files', %q{
  In order to remove amswers files
   As an answer author
   I want to be able to delete attach file
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Answer'
  end
 
  scenario "Author delete attach file", js: true do
    within '.answers' do
      click_on 'del'
    end
    
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario "No Author delete attach file", js: true do
    click_on 'Sign Out'
    sign_in(user2)
    visit "/questions/1"

    expect(page).to_not have_link 'del'
  end
end 