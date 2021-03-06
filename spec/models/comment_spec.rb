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

require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { should validate_presence_of :body }
  it { should validate_presence_of :commentable_id }
  it { should belong_to :commentable }
  it { should belong_to :user }
  it { should have_many :votes }
end
