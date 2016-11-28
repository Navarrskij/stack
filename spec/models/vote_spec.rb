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

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it {should belong_to(:votable)}
  it {should belong_to(:user)}
  it { should validate_inclusion_of(:value).in_array [-1, 1] }
end
