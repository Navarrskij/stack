require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question2) }
  describe 'Get index' do
    let(:questions) { create_list(:question, 2) }
    before {get :index}

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'Get show' do
    before {get :show, id: question}

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end 

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'Get new' do
    sign_in_user
    before {get :new}

    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end 

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end 

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    sign_in_user
    context 'with valid attributes' do

      it 'save the new question in a database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count)
      end 

      it 'redirect_to show views' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to questions_path
      end

       it 'question association to user ' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(@user.questions, :count)
      end 
    end
    context 'with invalid attributes' do

      it 'doesnt save new question in a database' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end 

      it 're_renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH update' do
    sign_in_user
    
    context 'is author change attributes' do
    let(:question) { @user.questions.create(title: 'Myquestion', body: 'Mybody') }

      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end 

       it 'change question attributes' do
        patch :update, id: question, question: {title: 'new title', body: 'new body'}, format: :js
        question.reload
        expect(question.body).to eq 'new body'
        expect(question.title).to eq 'new title'
      end

      it 'render to update template' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'is not author change attributes' do
      let(:user) { create(:user) } 
   
      it 'not change question attributes' do
        patch :update, id: question, question: {title: 'title2', body: 'body2'}, format: :js
        question.reload
        expect(question.body).to_not eq "body2"
        expect(question.title).to_not eq "title2"
      end 
    end
  end

  describe 'DELETE destroy' do
    sign_in_user
    
    context 'is author' do
      let!(:question) { @user.questions.create(title: '111', body: '222') }
      before { question }

      it 'delete question' do
        expect { delete :destroy, params: { id: question.id } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question.id }
        expect(response).to redirect_to questions_path
      end
    end

    context 'is not author' do
      let(:question) { create(:user).questions.create(title: '111', body: '222') }
      before { question }

      it 'not delete question' do
        expect { delete :destroy, params: { id: question.id } }.to_not change(Question, :count)
      end
    end
  end
end
