require_relative 'acceptance_helper'
 
feature 'Choose best answer', %q{
   In order to help community
   As question author
   I want to choose the best answer
} do

  given(:author) { create(:user) }
  given(:user2) { create(:user) }  
  given(:question) { create(:question, user: author) }
  given!(:answer1) { create(:answer, question: question, body: 'answer111', best: true) }
  given!(:answer2) { create(:answer, question: question, body: 'answer222') }  
 
 
  scenario "Author set best answer to his question", js: true do
    sign_in(author)
    visit question_path(question)
 
    within ".answers" do
      click_link 'Make best'
    end
 
    first_answer = page.find(:css, '.answers', match: :first)
    expect(first_answer.text).to have_content 'answer222'   
  end
 
  scenario "Non author tries to set best answer other users question", js: true do
    sign_in(user2)
    visit question_path(question)
    expect(page).to_not have_link 'Make best'
  end

 	scenario "Non Authenticated user tries to set best answer other users question", js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Make best'
	end
end 