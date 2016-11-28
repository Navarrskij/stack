# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text
#  commentable_type :string
#  commentable_id   :integer
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :comment do
    user
    sequence(:body, 1) { |n| "bodynew#{n}" }
    association :commentable, factory: :question
	end
	factory :comment2, class: 'Comment'  do
    user
    body nil
    association :commentable, factory: :question
	end
end