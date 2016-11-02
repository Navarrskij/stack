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
#  best        :boolean
#

class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy
  validates :body, presence: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def best!
  	transaction do
  		question.answers.update_all best: false
  		update! best: true
  	end
  end
end

