require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
	let(:question) { create(:question) }

	describe "POST create" do
    sign_in_user

    it "subscribe to question" do
      expect { post :create, params: { question_id: question.id, format: :js } }.to change(@user.subscriptions.where(question: question), :count).by(1)
    end

    it "render template create" do
      post :create, params: { question_id: question.id, format: :js }
      expect(response).to render_template :create
    end
  end

  describe "DELETE destroy" do
    let!(:subscription) { create(:subscription, question: question) }
    sign_in_user
    before { subscription.update(user_id: @user.id) }

    it "can unsubscribe to question" do
      expect { delete :destroy, params: { id: subscription.id, format: :js } }.to change(question.subscriptions, :count).by(-1)
    end

    it "render template destroy" do
      delete :destroy, params: { id: subscription.id, format: :js }
      expect(response).to render_template :destroy
    end
  end
end
