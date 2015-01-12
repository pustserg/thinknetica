# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  # before_save :parse_tags

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :taggings
  has_many :questions, through: :taggings

end
