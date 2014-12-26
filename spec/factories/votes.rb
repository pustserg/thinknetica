# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  voteable_id   :integer
#  voteable_type :string(255)
#

FactoryGirl.define do
  factory :vote do
    user nil
status "MyString"
  end

end
