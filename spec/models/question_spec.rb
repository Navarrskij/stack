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

require 'rails_helper'

RSpec.describe Question, type: :model do
	it {should validate_presence_of :title}
    #it 'validates presence of title' do
	#expect(Question.new(body: 'word')).to_not be_valid

	it {should validate_presence_of :body}
    #it 'validates presence of body' do
	#expect(Question.new(title: '1111')).to_not be_valid
	#end
end
