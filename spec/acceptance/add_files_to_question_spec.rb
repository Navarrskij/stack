require_relative 'acceptance_helper'
 
feature 'Add files to question', %q{
   In order to illustrate my question
   As an question author
   I want to be able to attach file
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end
 
  scenario "User add files when ask question" do

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

    within all('.nested-fields').first do
       attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add file'

    within all('.nested-fields').last do
       attach_file 'File', "#{Rails.root}/spec/support/1.txt"
     end 

    click_on 'Create Question'
    click_on 'Show'
    
    within '.question' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link '1.txt', href: '/uploads/attachment/file/2/1.txt'
    end
  end
end 