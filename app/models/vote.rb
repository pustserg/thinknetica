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

class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, polymorphic: true
  validates :status, presence: true

  scope :likes, -> { where(status: "+") }
  scope :dislikes, -> { where(status: "-") }
  scope :by_type, -> (type) { where(voteable_type: type) }

  after_save :calculate_user_karma

  private
  def calculate_user_karma
    self.voteable.user.delay.calculate_karma
  end
end
