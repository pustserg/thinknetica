# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#

class Tag < ActiveRecord::Base
  # before_save :parse_tags

  validates :name, presence: true

  has_many :taggings
  has_many :questions, through: :taggings

  # private
  
  # def parse_tags
  #   tag_list = self.name.split(', ')
  #   tag_list.each do |t|
  #     tag = Tag.new(name: t)
  #     tag.save
  #   end
  # end
end
