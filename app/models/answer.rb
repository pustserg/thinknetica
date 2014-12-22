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

  def make_best
    
    if question.best_answer.nil?
      update(best: true)
    elsif question.best_answer != self
      question.best_answer.update(best: false)
      update(best: true)
    end

  end

end
