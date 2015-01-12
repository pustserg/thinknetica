# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text             not null
#  commentable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  commentable_type :string(255)
#

class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :votes, as: :voteable, dependent: :destroy

  validates :body, :user_id, :commentable_id, presence: true

  def vote_up(user)
    votes.create(user: user, status: "+")
  end

  def vote_down(user)
    votes.create(user: user, status: "-")
  end
end
