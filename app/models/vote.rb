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

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true
  validates :status, presence: true
end
