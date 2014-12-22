# == Schema Information
#
# Table name: comments
#
#  id             :integer          not null, primary key
#  body           :text             not null
#  commentable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  user_id        :integer
#

FactoryGirl.define do
  factory :comment do
    body "MyText"
    association :commentable, factory: :question
  end

  factory :wrong_comment, class: "Comment" do
    body nil
    commentable nil
  end

end
