# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#

class Tag < ActiveRecord::Base
  validates :name, presence: true

  has_many :taggings
  has_many :questions, through: :taggings
end
