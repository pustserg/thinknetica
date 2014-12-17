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

  def make_best
    update(best: true)
  end

end
