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
  include VoteableModel
  
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  validates :body, :user_id, :commentable_id, presence: true

  def question
    commentable_type == "Question" ? commentable : commentable.question
  end
end
