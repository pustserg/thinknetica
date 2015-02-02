# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean          default(FALSE)
#  karma                  :integer          default(0)
#

FactoryGirl.define do

  sequence :email do |n|
    "testuser-#{n}@think.test"
  end

  factory :user do
    email
    password 'testpassword'
    password_confirmation 'testpassword'
    confirmed_at Time.now
  end

end
