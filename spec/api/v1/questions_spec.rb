require 'rails_helper'

describe 'Questions API' do
  describe 'Get/index' do
    context 'unauthorized' do
      it 'renurn 410 status if there is not access_token' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'renurn 410 status if there access_token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

    context 'answers' do
      it 'included in question object' do
        expect(response.body).to have_json_size(1).at_path("questions/0/answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end

    end

    end
  end
end