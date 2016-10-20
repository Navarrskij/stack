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

FactoryGirl.define do
  factory :answer do
    sequence(:body, 1) { |n| "bodynew#{n}" }
    user
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
