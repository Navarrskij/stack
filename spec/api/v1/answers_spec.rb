require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }
  describe 'Get/index' do
    let(:url_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get url_path, format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return list of answers' do
        expect(response.body).to have_json_size(3).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'Get/show' do
    let!(:answer) { create(:answer, question: question) }
    let(:url_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get url_path, format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      let(:commentable) { answer }
      it_behaves_like "API Commentable"

      let(:attachmentable) { answer }
      it_behaves_like "API Attachable"
    end
  end

  describe 'post/create' do
    let!(:question) { create(:question) }
    let(:url_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like "API Authenticable"

    context 'authorized' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post url_path, params: { format: :json, access_token: access_token.token, answer: { body: 'answer body' }, question_id: question }
          expect(response.status).to eq 201 
        end

        it 'save answer in database' do
          expect { post url_path, params: { format: :json, access_token: access_token.token, answer: { body: 'answer body' }, question_id: question } }.to change(user.answers.where(question: question), :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post url_path, params: { format: :json, access_token: access_token.token, answer: { body: '' }, question_id: question }
          expect(response.status).to eq 422
        end

        it 'does not save answer in database' do
          expect { post url_path, params: { format: :json, access_token: access_token.token, answer: { body: '' }, question_id: question } }.to_not change(Answer, :count)
        end
      end
    end
  end
end