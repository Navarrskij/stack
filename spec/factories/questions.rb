# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

FactoryGirl.define do
  sequence :title do |n|
    "title#{n}"
  end
  sequence :body do |n|
    "body#{n}"
  end
  factory :question do
    user
    title
    body 

  factory :question_answers do
    transient do
        answer_count 3
      end
 
    after(:create) do |question, evaluator|
      create_list(:answer, evaluator.answer_count, question: question)
    end
  end
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end

  factory :question2, class: "Question" do
    user
    title "MyString"
    body "MyText"
  end
end
