# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

class Question < ActiveRecord::Base

  has_many :answers
  validates :title, :body, presence: true

end
