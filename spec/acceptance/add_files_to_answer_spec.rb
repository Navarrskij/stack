require_relative 'acceptance_helper'
 
feature 'Add files to answer', %q{
   In order to illustrate my answer
   As an answer author
   I want to be able to attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question)}

  background do
    sign_in(user)
    visit question_path(question)
  end
 
  scenario "User add file when create answer", js: true do

    fill_in 'Body', with: 'text text text'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create Answer'

    within '.answers' do
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end
end 