require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
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
    before {get :new}
    it 'assigns a new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end 
    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'Get edit' do
    before {get :edit, id: question}
    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end 
    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'save the new question in a database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end 
      it 'redirect_to show views' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
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
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(assigns(:question)).to eq question
      end 
       it 'change question attributes' do
        patch :update, id: question, question: {title: 'new title', body: 'new body'}
        question.reload
        expect(question.body).to eq 'new body'
        expect(question.title).to eq 'new title'
      end
      it 'redirect to updated question' do
        patch :update, id: question, question: attributes_for(:question)
        expect(response).to redirect_to question
      end
    end
    context 'invalid attributes' do
      it 'doesnt no change question attributes' do
        patch :update, id: question, question: {title: 'new title', body: nil}
        question.reload
        expect(question.body).to eq "MyText"
        expect(question.title).to eq "MyString"
      end 
      it 're_renders edit view' do
        patch :update, id: question, question: {title: 'new title', body: nil}
        expect(response).to render_template :edit
      end
    end
  end
end
