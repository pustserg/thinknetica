# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  slug       :string(255)
#

FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end


end
