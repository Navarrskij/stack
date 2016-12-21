class AnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.answer.subject
  #
  default :from => "test@example.com"

  layout "mailer"

  def notify(user, answer)
    @user = user
    @answer = answer
    mail to: @user.email
  end
end
