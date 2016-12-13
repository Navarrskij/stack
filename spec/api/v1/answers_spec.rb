require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }
  describe 'Get/index' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it 'return 401 status if there is not access_token' do
        get url, format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there access_token is invalid' do
        get url, format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get url, format: :json, access_token: access_token.token }

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
    let!(:comment) { create(:answer_comment, commentable: answer) }
    let!(:attachment) { create(:answer_attachment, attachmentable: answer) }
    let(:url) { "/api/v1/answers/#{answer.id}" }

    context 'unauthorized' do
      it 'renurn 401 status if there is not access_token' do
        get url, format: :json
        expect(response.status).to eq 401
      end

      it 'renurn 401 status if there access_token is invalid' do
        get url, format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get url, format: :json, access_token: access_token.token }

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

      %w(id body created_at user_id).each do |attr|
        it "answer comment contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end

      it 'contains comment' do
        expect(response.body).to have_json_size(1).at_path('answer/comments')
      end

      %w(id created_at).each do |attr|
        it "answer attachment contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
        end
      end

        it 'contains attachment' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

      it "answer attachment contains file name" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("answer/attachments/0/name")
      end

      it "answer attachment contains url path" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/path")
      end
    end
  end

  describe 'post/create' do
    let!(:question) { create(:question) }
    let(:url) { "/api/v1/questions/#{question.id}/answers" }

    context 'unauthorized' do
      it 'return 401 status if there is not access_token' do
        post url, params: { format: :json, answer: attributes_for(:answer), question_id: question }
        expect(response.status).to eq 401
      end

      it 'return 401 status if there access_token is invalid' do
        post url, params: { format: :json, answer: attributes_for(:answer), question_id: question, access_token: '112332' }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        it 'returns 201 status code' do
          post url, params: { format: :json, access_token: access_token.token, answer: { body: 'answer body' }, question_id: question }
          expect(response.status).to eq 201 
        end

        it 'save answer in database' do
          expect { post url, params: { format: :json, access_token: access_token.token, answer: { body: 'answer body' }, question_id: question } }.to change(user.answers.where(question: question), :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post url, params: { format: :json, access_token: access_token.token, answer: { body: '' }, question_id: question }
          expect(response.status).to eq 422
        end

        it 'does not save answer in database' do
          expect { post url, params: { format: :json, access_token: access_token.token, answer: { body: '' }, question_id: question } }.to_not change(Answer, :count)
        end
      end
    end
  end
end