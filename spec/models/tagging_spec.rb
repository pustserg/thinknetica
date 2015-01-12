# == Schema Information
#
# Table name: taggings
#
#  id          :integer          not null, primary key
#  question_id :integer
#  tag_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Tagging, :type => :model do
  it { should belong_to :question }
  it { should belong_to :tag }
end
