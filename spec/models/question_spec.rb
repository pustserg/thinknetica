# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many :answers }
end
