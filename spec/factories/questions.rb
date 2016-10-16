# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :question do
    user
    title "MyString"
    body "MyText"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
