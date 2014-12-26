# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  body             :text             not null
#  commentable_id   :integer
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  commentable_type :string(255)
#

FactoryGirl.define do
  factory :question_comment, class: "Comment" do
    body "question comment"
    association :commentable, factory: :question
  end

  factory :answer_comment, class: "Comment" do
    body "answer comment"
    association :commentable, factory: :answer
  end

end
