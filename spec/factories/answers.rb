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
    question
    body "my answer"    
  end

  factory :invalid_answer, class: "Answer" do
    question
    body nil
  end

end
