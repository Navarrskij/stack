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

  describe 'Get/list_questions' do
    let(:url) { '/api/v1/questions/list_questions' }
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
    end
  end

  describe 'Get/show' do
    let!(:question) { create(:question) }
    let(:url) { "/api/v1/questions/#{question.id}" }
    context 'unauthorized' do
      it 'renurn 410 status if there is not access_token' do
        get url, format: :json
        expect(response.status).to eq 401
      end

      it 'renurn 410 status if there access_token is invalid' do
        get url, format: :json, access_token: '112332'
        expect(response.status).to eq 401
      end
    end
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comment) { create(:comment, commentable: question) }
      let!(:attachment) { create(:question_attachment, attachmentable: question) }
      let(:url) { "/api/v1/questions/#{question.id}" }

      before { get url, format: :json, access_token: access_token.token }

      it 'return 200 status' do
        expect(response).to be_success
      end

      it 'return question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      %w(id body created_at user_id).each do |attr|
        it "question comment contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end

      it 'contains comment' do
        expect(response.body).to have_json_size(1).at_path('question/comments')
      end

      %w(id created_at).each do |attr|
        it "question attachment contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
        end
      end

        it 'contains attachment' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end

      it "question attachment contains file name" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/0/name")
      end

      it "question attachment contains url path" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/path")
      end
    end
  end

  describe 'post/create' do
    context 'unauthorized' do
      it 'return 401 status if there is not access_token' do
        post '/api/v1/questions', params: { question: attributes_for(:question), format: :json }
        expect(response.status).to eq 401
      end

      it 'return 401 status if there access_token is invalid' do
        post '/api/v1/questions', params: { question: attributes_for(:question), access_token: '112332', format: :json }
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post "/api/v1/questions", params: { format: :json, access_token: access_token.token, question: { title: 'question title', body: 'question body' } }
          expect(response.status).to eq 201 
        end

        it 'save question in database' do
          expect { post "/api/v1/questions", params: { format: :json, access_token: access_token.token, question: { title: 'question title', body: 'question body' } } }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post "/api/v1/questions", params: { format: :json, access_token: access_token.token, question: { title: '', body: 'question body' } }
          expect(response.status).to eq 422
        end

        it 'does not save question in database' do
          expect { post "/api/v1/questions", params: { format: :json, access_token: access_token.token, question: { title: '', body: 'question body' } } }.to_not change(user.questions, :count)
        end
      end
    end
  end
end