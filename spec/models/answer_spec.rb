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
#  best        :boolean
#

require 'rails_helper'

RSpec.describe Answer, type: :model do

  it_behaves_like 'votable'
  
  it {should belong_to(:question)}
  it {should validate_presence_of :body}
  it {should belong_to(:user)}
  it {should have_many(:attachments).dependent(:destroy)}
  it {should have_many(:votes)}
  it {should have_many(:comments).dependent(:destroy)}
  it {should accept_nested_attributes_for :attachments}

	describe 'best!' do
    let(:author)    { create(:user) }    
    let(:question)  { create(:question, user: author) }
    let!(:answer1)  { create(:answer, question: question) } 
    let!(:answer2)  { create(:answer, question: question) }

    context 'set best answer' do
      before do
        answer1.best!
      end

      it { expect(answer1).to be_best }
    end

    context 'update attribute to best in other answer' do
      before do
        answer1.best!
        answer2.best!
        answer1.reload
      end

      it { expect(answer2).to be_best }
      it { expect(answer1).to_not be_best }      
    end
  end
end
