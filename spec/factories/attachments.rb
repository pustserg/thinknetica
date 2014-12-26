# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: attachments
#
#  id                  :integer          not null, primary key
#  file                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  attachmentable_id   :integer
#  attachmentable_type :string(255)
#

FactoryGirl.define do
  factory :attachment do
    file "MyString"
  end

end
