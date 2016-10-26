require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  
  describe 'POST create' do
    let!(:question) { create(:question) }
    sign_in_user
    context 'with valid attributes' do

      it 'save the new answer in a database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
      end 

      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end

      it 'answer association to user ' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(@user.answers, :count).by(1)
      end 
    end

    context 'with invalid attributes' do

      it 'doesnt save new answer in a database' do
        expect { post :create, question_id: question, answer: {body: nil}, format: :js }.to_not change(Answer, :count)
      end 
      
      it 'redirect to show view questions' do
        post :create, question_id: question, answer: {body: nil}, format: :js
        expect(response).to render_template :create
      end 
    end
  end

  describe 'DELETE destroy' do
    sign_in_user

    context 'is author' do
      let(:question) { @user.questions.create(title: '111', body: '222') }
      let!(:answer)   { question.answers.create(body: '333', user_id: @user.id) }
      before { answer }
 
      it 'delete answer from database' do
      expect { delete :destroy, params: { id: answer.id, format: :js } }.to change(question.answers, :count).by(-1)
      end
 
      it 'render delete template' do
        delete :destroy, params: { id: answer.id , format: :js}
        expect(response).to render_template :destroy
      end
     end
 
    context 'is not author' do
      let(:user)     { create(:user) } 
      let(:question) { user.questions.create(title: '111', body: '222') }
      let!(:answer)   { question.answers.create(body: '333', user_id: user.id) }
      
 
      it 'not delete answer from database' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH update' do
    sign_in_user
    context 'is author' do
      let(:question) { @user.questions.create(title: '111', body: '222') }
      let(:answer)   { question.answers.create(body: '333', user_id: @user.id) }

    it 'assigns the requested answer to @answer' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(assigns(:answer)).to eq answer
      end 

    it 'change answer attributes' do
      patch :update, id: answer, question_id: question, answer: {body: 'new body'}, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
      end

    it 'render update template' do
      patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update
      end
    end
    context 'is not author' do
      let(:user)     { create(:user) } 
      let(:question) { user.questions.create(title: '111', body: '222') }
      let(:answer)   { question.answers.create(body: '333', user_id: user.id) }

      it 'not change answer attributes' do

      patch :update, id: answer, question_id: question, answer: {body: 'new body'}, format: :js
      answer.reload

      expect(answer.body).to_not eq 'new body'
      end
    end
  end   
end
