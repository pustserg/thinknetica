# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  status        :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  voteable_id   :integer
#  voteable_type :string(255)
#

require 'rails_helper'

RSpec.describe Vote, :type => :model do
  subject { build :vote }
  it { should belong_to :user }
  it { should belong_to :voteable }
  it { should validate_presence_of :status }

  it 'should calculate user reputation after creating' do
    expect(subject).to receive(:calculate_user_karma)
    subject.save!
  end
end 
