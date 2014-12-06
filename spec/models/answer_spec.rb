# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#

require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should validate_presence_of :body }
  it { should belong_to :question }
end
