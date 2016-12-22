require 'rails_helper'

RSpec.describe NewAnswerJob, type: :job do
  let(:question) { create(:question, user: users.first) }
  let(:answer) { create(:answer, question: question) }
  let!(:subscription) { create(:subscription, question: question, user: users.second) }
  let(:users) { create_list(:user, 2) }

  it 'sends notify to users' do
    users.each do |user|
      expect(AnswerMailer).to receive(:notify).with(user, answer).and_call_original
      NewAnswerJob.perform_now(answer)
    end  
  end
end