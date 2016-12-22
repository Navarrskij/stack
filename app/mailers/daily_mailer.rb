class DailyMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject

  default :from => "test@example.com"
  
  def digest(user)
    @questions = Question.where(created_at: Date.yesterday...Date.today)
    mail to: user.email
  end
end
