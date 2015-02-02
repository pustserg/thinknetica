# == Schema Information
#
# Table name: favorites
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

FactoryGirl.define do
  factory :favorite do
    user ""
question ""
  end

end
