# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#  user_id     :integer
#  best        :boolean          default(FALSE)
#

class Answer < ActiveRecord::Base

  validates :body, :question_id, :user_id, presence: true

  belongs_to :question
  belongs_to :user

  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable
  has_many :votes, as: :voteable

  accepts_nested_attributes_for :attachments


  def make_best
    
    if question.best_answer.nil?
      update(best: true)
    elsif question.best_answer != self
      question.best_answer.update(best: false)
      update(best: true)
    end

  end

  def vote_up(user)
    votes.create(user: user, status: "+")
  end

  def vote_down(user)
    votes.create(user: user, status: "-")
  end
  
end
