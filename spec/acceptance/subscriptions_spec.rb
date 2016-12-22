require_relative 'acceptance_helper'

feature 'Subscribe to answers of question', %q{
  In order to send new answers to email
  As Authenticated User
  I want to be able to subscribe question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_question) { create(:question, user: user) }

  context 'Authenticated user' do
    scenario 'User can subscribe tp question', js: true do
      sign_in(user)
      visit question_path(question)

      fill_in 'Body', with: 'bla bla bla'
      click_on 'Create Answer'
      open_email(user.email)

      expect(current_email).to have_content('bla bla bla')
      expect(page).to_not have_link 'unsubscribe'

      click_link 'unsubscribe'
      clear_emails
      fill_in 'Body', with: 'answer'
      click_on 'Create Answer'
      open_email(user.email)

      expect(current_email).to be_nil
      expect(page).to have_link 'subscribe'
    end

    scenario 'Author question unsubscribes his question', js: true do
      sign_in(user)
      visit question_path(user_question)

      click_link 'unsubscribe'

      expect(page).to_not have_link 'unsubscribe'
      expect(page).to have_link 'subscribe'
    end

    scenario 'Non-authenticated user cannot to subscribe' do
      visit question_path(question)

      expect(page).to_not have_link 'subscribe'
      expect(page).to_not have_link 'unsubscribe'
    end
  end
end