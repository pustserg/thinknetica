# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#

class Answer < ActiveRecord::Base

  belongs_to :question
  belongs_to :user
  validates :body, presence: true

end
