module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
  end

  def was_vote_up?(user)
    votes.find_by(user: user, value: 1).present?
  end

  def was_vote_down?(user)
    votes.find_by(user: user, value: -1).present?
  end

  def revoke_vote(user)
    votes.find_by(user: user).try(:destroy)
  end

  def rating
    votes.where(votable: self).sum(:value)
  end

  def vote_up(user)
    if user.author_of?(self)
      flash[:notice] = "Don't vote it post"
    elsif was_vote_up?(user)
      flash[:notice] = "Can't vote this post twice"
    else
      revoke_vote(user) if was_vote_down?(user)
      votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    if user.author_of?(self)
      flash[:notice] = "Don't vote it post"
    elsif was_vote_down?(user)
      flash[:notice] = "Can't vote this post twice"
    else
      revoke_vote(user) if was_vote_up?(user)
      votes.create(user: user, value: -1)
    end
  end
end