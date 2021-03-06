# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

class Question < ApplicationRecord
  
  after_create :subscribe_author
  include Votable

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates :body, :title, presence: true
  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

private

  def subscribe_author
    subscriptions.create(user: self.user)
  end
end
