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

FactoryGirl.define do
  factory :answer do
    body "my answer"    
  end

end
