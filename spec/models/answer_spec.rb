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

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it {should belong_to(:question)}
  it {should validate_presence_of :body}
  it {should belong_to(:user)}
end
