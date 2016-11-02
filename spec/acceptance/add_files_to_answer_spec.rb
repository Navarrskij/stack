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
 
  scenario "User add files when create answer", js: true do

    fill_in 'Body', with: 'text text text'

     within all('.nested-fields').first do
       attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'add file'

    within all('.nested-fields').last do
       attach_file 'File', "#{Rails.root}/spec/support/1.txt"
     end 
     
    click_on 'Create Answer'

    within '.answers' do
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).to have_link '1.txt', href: '/uploads/attachment/file/2/1.txt'
    end
  end
end 