require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST create' do
    sign_in_user
    context 'with valid attributes' do

      it 'save the new answer in a database' do
        expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count)
      end 

      it 'redirect_to question' do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
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
end
