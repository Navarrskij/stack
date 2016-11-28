# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_id   :integer
#  votable_type :string
#  value        :integer
#  user_id      :integer
#

FactoryGirl.define do
  factory :vote do
 		votable { |v| v.association(:question) }
  	user
  	value 1
  end
end
