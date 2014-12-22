# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  body           :text             not null
#  commentable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Comment < ActiveRecord::Base

  validates :body, :commentable_id, presence: true
  belongs_to :commentable, polymorphic: true
end
