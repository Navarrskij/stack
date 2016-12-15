require 'rails_helper'

describe 'Questions API' do
  describe 'Get/index' do
    let(:url_path) { "/api/v1/questions" }

    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get url_path, format: :json, access_token: access_token.token }

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
    let(:url_path) { '/api/v1/questions' }
    
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }

      before { get url_path, format: :json, access_token: access_token.token }

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
    let(:url_path) { "/api/v1/questions/#{question.id}" }
   
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
     
      before { get url_path, format: :json, access_token: access_token.token }

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

      let(:commentable) { question }
      it_behaves_like "API Commentable"

      let(:attachmentable) { question }
      it_behaves_like "API Attachable"
    end
  end

  describe 'post/create' do
    let(:url_path) { "/api/v1/questions" }
    let(:method) { :post }

    it_behaves_like "API Authenticable"

    context 'authorized' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      context 'with valid attributes' do
        it 'returns 201 status code' do
          post url_path, params: { format: :json, access_token: access_token.token, question: { title: 'question title', body: 'question body' } }
          expect(response.status).to eq 201 
        end

        it 'save question in database' do
          expect { post url_path, params: { format: :json, access_token: access_token.token, question: { title: 'question title', body: 'question body' } } }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns 422 status code' do
          post url_path, params: { format: :json, access_token: access_token.token, question: { title: '', body: 'question body' } }
          expect(response.status).to eq 422
        end

        it 'does not save question in database' do
          expect { post url_path, params: { format: :json, access_token: access_token.token, question: { title: '', body: 'question body' } } }.to_not change(user.questions, :count)
        end
      end
    end
  end
end