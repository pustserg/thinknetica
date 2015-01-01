# -*- encoding : utf-8 -*-
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
#  slug       :string(255)
#

class Question < ActiveRecord::Base
  before_save :create_slug

  validates :title, :body, :user_id, presence: true

  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable 
  has_many :votes, as: :voteable
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user

  accepts_nested_attributes_for :attachments
  accepts_nested_attributes_for :tags

  def best_answer
    answers.where(best: true).first
  end

  def vote_up(user)
    votes.create(user: user, status: "+")
  end

  def vote_down(user)
    votes.create(user: user, status: "-")
  end

  def to_param
    "#{id}_#{slug}".parameterize
  end

  def create_slug
      self.slug = Russian::transliterate(self.title) if !self.slug
  end

  def tag_list
    list = []
    self.tags.each do |t|
      list << t.name
    end
    list.join(', ')
  end

  def tag_list=(tag_list)
    self.tags = []
    tags = tag_list.split(', ')
    tags.each do |t|
      tag = Tag.find_or_create_by(name: t)
      self.tags << tag unless self.tags.include?(tag)
    end
  end

end
