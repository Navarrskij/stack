class NewAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subs|
      AnswerMailer.notify(subs.user, answer).deliver_later
    end
  end
end
