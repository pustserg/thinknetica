# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

require 'rails_helper'

RSpec.describe Question, :type => :model do
    
  it { should have_many :answers }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should  accept_nested_attributes_for :attachments}

end
