require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST create' do
    sign_in_user
    context 'with valid attributes' do

      it 'save the new answer in a database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
      end 

      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end

      it 'answer association to user ' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(@user.answers, :count).by(1)
      end 
    end

    context 'with invalid attributes' do

      it 'doesnt save new answer in a database' do
        expect { post :create, question_id: question, answer: {body: nil} }.to_not change(Answer, :count)
      end 
      
      it 'redirect to show view questions' do
        post :create, question_id: question, answer: {body: nil}
        expect(response).to render_template 'questions/show'
      end 
    end
  end

  describe 'DELETE destroy' do
    sign_in_user

    context 'is author' do
      let(:question) { @user.questions.create(title: '111', body: '222') }
      let(:answer)   { question.answers.create(body: '333', user_id: @user.id) }
      before { answer }
 
      it 'delete answer from database' do
      expect { delete :destroy, params: { id: answer.id } }.to change(question.answers, :count).by(-1)
      end
 
      it 'redirect_to question view' do
        delete :destroy, params: { id: answer.id }
        expect(response).to redirect_to question
      end
     end
 
    context 'is not author' do
      let(:user)     { create(:user) } 
      let(:question) { user.questions.create(title: '111', body: '222') }
      let(:answer)   { question.answers.create(body: '333', user_id: user.id) }
      before { answer }
 
      it 'not delete answer from database' do
        expect { delete :destroy, params: { id: answer.id } }.to_not change(Answer, :count)
      end
    end
  end
end
