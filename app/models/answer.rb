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
#

class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

end
