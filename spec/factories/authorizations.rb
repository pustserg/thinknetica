# == Schema Information
#
# Table name: authorizations
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :authorization do
    user nil
provider "MyString"
uid "MyString"
  end

end
