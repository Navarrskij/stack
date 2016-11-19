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

class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user
  validates :value, inclusion: { in: [-1, 1] }
end
