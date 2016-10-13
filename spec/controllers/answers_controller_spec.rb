require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST create' do
    context 'with valid attributes' do
      it 'save the new answer in a database' do
        expect { post :create, answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end 
      it 'redirect_to show views' do
        post :create, answer: attributes_for(:answer)
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    context 'with invalid attributes' do
      it 'doesnt save new answer in a database' do
        expect { post :create, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end 
    end
  end
end
