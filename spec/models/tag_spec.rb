# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  taggings_count :integer          default(0)
#

require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { should validate_presence_of :name }
end
