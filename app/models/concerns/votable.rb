module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def was_vote_up?(user)
    votes.exists?(user: user, value: 1)
  end

  def was_vote_down?(user)
    votes.exists?(user: user, value: -1)
  end

  def revoke_vote(user)
    votes.find_by(user: user).try(:destroy)
  end

  def rating
    votes.sum(:value)
  end

  def vote_up(user)
    vote(user, 1)
  end

  def vote_down(user)
    vote(user, -1)
  end

  private

  def vote(user, val)
    if user.author_of?(self)
      error = "Don't vote it post"
    else
      create_vote = (was_vote_down?(user) && val == -1) || (was_vote_up?(user) && val == 1) ? false : true
      revoke_vote(user) 
      votes.create(user: user, value: val) if create_vote
    end
    error ? [false, error] : true 
  end
end