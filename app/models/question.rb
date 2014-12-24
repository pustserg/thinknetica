# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Question < ActiveRecord::Base

  validates :title, :body, :user_id, presence: true

  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable 
  belongs_to :user

  accepts_nested_attributes_for :attachments

  def best_answer
    answers.where(best: true).first
  end

end
