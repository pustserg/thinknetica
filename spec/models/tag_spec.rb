# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should have_many(:questions).through(:taggings) }
end
