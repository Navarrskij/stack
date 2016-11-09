require 'rails_helper'

shared_examples 'votable' do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  describe 'rating' do
    context 'positive vote' do
      before { 2.times {create(:vote, value: 1, votable: model, user: create(:user)) } }

      it { expect(model.rating).to eq(2) }
    end

    context 'negative vote' do
      before { 2.times {create(:vote, value: -1, votable: model, user: create(:user)) } }

      it { expect(model.rating).to eq(-2) }
    end

    context 'zero vote' do
      it { expect(model.rating).to eq(0) }
    end    
  end

  describe 'was_vote_up?' do
    context 'when have votes up' do
      before { create(:vote, value: 1, votable: model, user: user) }

      it {expect(model.rating).to eq(1) }
    end 
  end

  describe 'was_vote_down?' do
    context 'when have votes down' do
      before { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model.rating).to eq(-1) }
    end  
  end

  describe 'revoke_vote' do
    context 'when was vote_up' do
      before do
        create(:vote, value: 1, votable: model, user: user)
        model.revoke_vote(user)
      end

      it { expect(model.votes.find_by(user: user)).to be_nil }    
    end
  end

  describe 'vote_up' do
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }
    let(:user2) { create(:user) }    
    
    context "on other user post" do
      it { expect { model.vote_up(user2) }.to change{ model.rating }.by(1) }
    end

    context "on his own post" do
      it { expect { model.vote_up(user) }.to_not change{ model.rating }}
    end
  end

  describe 'vote_down' do
    let(:model) { create(described_class.to_s.underscore.to_sym, user: user) }
    let(:user2) { create(:user) }
    
    context "on other user post" do      
      it { expect { model.vote_down(user2) }.to change{ model.rating }.by(-1) }
    end

    context "on his own post" do
      it { expect { model.vote_down(user) }.to_not change{ model.rating }}
    end
  end
end