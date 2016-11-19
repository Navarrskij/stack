require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe 'POST create' do
    sign_in_user
    let(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question) }

    context 'with valid attributes' do
   
      it 'saves the comment to database' do
        expect { post :create, question_id: question, comment: attributes_for(:comment), format: :js }.to change(question.comments.where(user: @user), :count).by(1)
      end

      it 'renders create template' do
        post :create, question_id: question, comment: attributes_for(:comment), format: :js
        expect(response).to render_template :create
      end
    end
    context 'with invalid attributes' do

      it 'does not save the comment to database' do
        expect { post :create, question_id: question, comment: attributes_for(:comment2), format: :js }.to_not change(Comment, :count)
      end

      it 'renders create template' do
        post :create, question_id: question, comment: attributes_for(:comment2), format: :js
        expect(response).to render_template :create
      end
    end
  end
end



