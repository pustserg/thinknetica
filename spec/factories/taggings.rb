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

FactoryGirl.define do
  factory :tagging do
    
  end

end
