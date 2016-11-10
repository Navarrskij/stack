require 'rails_helper'

shared_examples 'votable' do

  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:model) { create(described_class.to_s.underscore.to_sym) }

  describe 'rating' do
    context 'positive and negative vote' do
      before { 2.times {create(:vote, value: 1, votable: model, user: create(:user)) } }
      before { 2.times {create(:vote, value: -1, votable: model, user: create(:user)) } }

      it { expect(model.rating).to eq(0) }
    end
  end

  describe 'was_vote_up?' do
    context 'when have votes up' do
      before { create(:vote, value: 1, votable: model, user: user) }

      it {expect(model.was_vote_up?(user)).to be true }
    end 

    context 'when have votes down' do
      before { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model.was_vote_up?(user)).to be false }
    end

    context 'when not any votes' do
      it { expect(model.was_vote_up?(user)).to be false }
    end
  end

  describe 'was_vote_down?' do
    context 'when have votes down' do
      before { create(:vote, value: -1, votable: model, user: user) }

      it { expect(model.was_vote_down?(user)).to be true }
    end 

    context 'when have votes up' do
      before { create(:vote, value: 1, votable: model, user: user) }

      it { expect(model.was_vote_down?(user)).to be false }
    end

    context 'when not any votes' do
      it { expect(model.was_vote_down?(user)).to be false }
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

    context "when voted vote up" do
      before { create(:vote, value: 1, votable: model, user: user2) }

      it "revoke vote down" do
        expect { model.vote_up(user2) }.to change{ model.rating }.by(-1)
      end
    end

    context "when voted vote down" do
      before { create(:vote, value: -1, votable: model, user: user2) }

      it "revoke to vote up" do
        expect { model.vote_up(user2) }.to change{ model.rating }.by(2)
      end
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

    context "when voted vote down" do
      before { create(:vote, value: -1, votable: model, user: user2) }

      it "revoke vote up" do
        expect { model.vote_up(user2) }.to change{ model.rating }.by(2)
      end
    end

    context "when voted vote up" do
      before { create(:vote, value: 1, votable: model, user: user2) }

      it "revoke to vote down" do
        expect { model.vote_up(user2) }.to change{ model.rating }.by(-1)
    end
  end
end