require 'rails_helper'

shared_examples 'voted' do
  describe 'PATCH vote_up' do
    sign_in_user

    let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

    context "on other user's post" do
      let(:params) do
        { id: model.id, format: :json }
      end

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "vote positive" do
        expect { patch :vote_up, params: params }.to change{ model.votes.where(user: @user).sum(:value) }.by(1)
      end
    end

    context "on his own post" do
      let(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }
      let(:params) do
        { id: model.id, format: :json}
      end

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "not change rating" do
        expect { patch :vote_up, params: params }.to_not change{ model.votes.where(user: @user).sum(:value) }
      end
    end

    context "when previously voted up" do
      let(:params) do 
        { id: model.id, format: :json }
      end

      before { model.votes.create(user: @user, value: 1) }

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "revote to vote down" do
        expect { patch :vote_up, params: params }.to change{ model.votes.where(user: @user).sum(:value) }.by(-1)
      end
    end
  end

  describe 'PATCH vote_down' do
    sign_in_user

    let(:model) { create(described_class.controller_name.classify.underscore.to_sym) }

    context "on other user's post" do
      let(:params) do 
        { id: model.id, format: :json }
      end

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "vote negative" do
        expect { patch :vote_down, params: params }.to change{ model.votes.where(user: @user).sum(:value) }.by(-1)
      end
    end

    context "on his own post" do
      let(:model) { create(described_class.controller_name.classify.underscore.to_sym, user: @user) }
      let(:params) do { id: model.id, format: :json }
      end

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "not change rating" do
        expect { patch :vote_up, params: params }.to_not change{ model.votes.where(user: @user).sum(:value) }
      end
    end

    context "when previously voted down" do
      let(:params) do 
        { id: model.id, format: :json }
      end

      before { model.votes.create(user: @user, value: -1) }

      it "assings the requested post to @votable" do
        patch :vote_up, params: params
        expect(assigns(:votable)).to eq model
      end

      it "crevote to vote up" do
        expect { patch :vote_down, params: params }.to change{ model.votes.where(user: @user).sum(:value) }.by(1)
      end
    end
  end  
end