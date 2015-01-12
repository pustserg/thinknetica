# == Schema Information
#
# Table name: taggings
#
#  id          :integer          not null, primary key
#  question_id :integer
#  tag_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :question
  belongs_to :tag
end
