# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  body           :text             not null
#  commentable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

class Comment < ActiveRecord::Base

  validates :body, :user_id, :commentable_id, presence: true
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end