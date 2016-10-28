# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :integer
#  user_id     :integer
#

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true

  def best!
  	transaction do
  		question.answers.update_all best: false
  		self.update_attributes best: true
  	end
  end
end

