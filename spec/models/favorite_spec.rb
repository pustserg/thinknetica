# == Schema Information
#
# Table name: favorites
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

RSpec.describe Favorite, :type => :model do
  it { should belong_to :user }
  it { should belong_to :question }
end
