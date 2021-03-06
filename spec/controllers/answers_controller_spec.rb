require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  
  it_behaves_like 'voted'
  
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
      let!(:answer) { question.answers.create(body: '333', user_id: @user.id) }
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
      let(:user) { create(:user) } 
      let(:question) { user.questions.create(title: '111', body: '222') }
      let!(:answer) { question.answers.create(body: '333', user_id: user.id) }
      
 
      it 'not delete answer from database' do
        expect { delete :destroy, params: { id: answer.id, format: :js } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH update' do
    sign_in_user
    context 'is author' do
      let(:question) { @user.questions.create(title: '111', body: '222') }
      let(:answer) { question.answers.create(body: '333', user_id: @user.id) }

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
      let(:user) { create(:user) } 
      let(:question) { user.questions.create(title: '111', body: '222') }
      let(:answer) { question.answers.create(body: '333', user_id: user.id) }

      it 'not change answer attributes' do

      patch :update, id: answer, question_id: question, answer: {body: 'new body'}, format: :js
      answer.reload

      expect(answer.body).to_not eq 'new body'
      end
    end
  end

  describe 'PATCH best' do
    sign_in_user
    context "is author of question" do
      let(:question) { @user.questions.create(title: 'title123', body: 'body123') }
      let(:user) { create(:user) } 
      let!(:answer1) { question.answers.create(body: 'answer 123', user: user) }
      let!(:answer2) { question.answers.create(body: 'answer 456', user: user, best: true) }

      it "assings the request answer to @answer" do
        patch :best, params: { id: answer1.id, format: :js }
        expect(assigns(:answer)).to eq answer1
      end

      it "do answer best attribute to true" do
        patch :best, params: { id: answer1.id, format: :js }
        answer1.reload
        answer2.reload
        expect(answer1).to be_best
        expect(answer2).to_not be_best
      end

      it "render best template" do
        patch :best, params: { id: answer1.id, format: :js }
        expect(response).to render_template :best
      end
    end

    context "is not author of question" do
      let(:user) { create(:user) }
      let(:question) { user.questions.create(title: 'Mytitle1', body: 'Mybody1') }      
      let(:answer) { question.answers.create(body: 'Mybody2', user: user) }

      it 'not change answer attributes' do
        expect { patch :best, params: { id: answer.id, format: :js } }.to_not change(answer, :best)
      end
    end    
  end 
end
