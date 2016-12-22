require 'rails_helper'

RSpec.describe Ability, type: :model do

  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:author_question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:author_answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer, user: other) }
    let(:author_subscription) { create(:subscription, user: user) }
    let(:other_subscription) { create(:subscription, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    it { should be_able_to :update, author_question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, author_answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, author_question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, author_answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :destroy, author_subscription }
    it { should_not be_able_to :destroy, other_subscription }

    it { should be_able_to :destroy, author_question.attachments.build }
    it { should_not be_able_to :destroy, other_question.attachments.build }
    it { should be_able_to :destroy, author_answer.attachments.build }
    it { should_not be_able_to :destroy, other_answer.attachments.build }

    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, author_question }
    it { should be_able_to :vote_up, other_answer }
    it { should_not be_able_to :vote_up, author_answer }

    it { should be_able_to :vote_down, other_question }
    it { should_not be_able_to :vote_down, author_question }
    it { should be_able_to :vote_down, other_answer }
    it { should_not be_able_to :vote_down, author_answer }

    it { should be_able_to :best, create(:answer, question: author_question) }
    it { should_not be_able_to :best, create(:answer, question: other_question) }

    it { should be_able_to :me, User }
  end
end
