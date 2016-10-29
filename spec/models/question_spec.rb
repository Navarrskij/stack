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

require 'rails_helper'

RSpec.describe Question, type: :model do
  it {should have_many(:answers).dependent(:destroy)}
  it {should belong_to(:user)}
  it {should have_many(:attachments)}
  it {should validate_presence_of :title}
  it {should validate_presence_of :body}
  it {should accept_nested_attributes_for :attachments}
end
