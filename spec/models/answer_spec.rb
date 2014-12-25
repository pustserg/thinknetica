# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#  user_id     :integer
#  best        :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Answer, :type => :model do

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it { should  accept_nested_attributes_for :attachments}


end
