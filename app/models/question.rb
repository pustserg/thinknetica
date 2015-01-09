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
#  answered   :boolean          default(FALSE)
#

class Question < ActiveRecord::Base

  has_many :answers, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :votes, as: :voteable, dependent: :restrict_with_error
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  before_save :create_slug

  scope :answered, -> { where(answered: true) }
  scope :not_answered, -> { where(answered: false) }

  accepts_nested_attributes_for :attachments

  searchable do
    text :title, :body
  end

  def best_answer
    answers.where(best: true).first
  end

  def make_answered
    update(answered: true)
  end

  # def answered?
  #   !best_answer.nil?
  # end

  # def self.has_best_answer
  #   result = []
  #   Question.all.each do |question|
  #     result << question if question.answered?
  #   end
  #   result
  # end

  # def self.without_best_answer
  #   result = []
  #   Question.all.each do |question|
  #     result << question unless question.answered?
  #   end
  #   result
  # end

  def vote_up(user)
    votes.create(user: user, status: "+")
  end

  def vote_down(user)
    votes.create(user: user, status: "-")
  end

  def to_param
    "#{id}-#{slug}".parameterize
  end

  def tag_list
    self.tags.map(&:name).join(', ')
  end

  def tag_list=(tag_list)
    self.tags = []
    tags = tag_list.split(', ')
    tags.each do |t|
      tag = Tag.find_or_create_by(name: t)
      self.tags << tag unless self.tags.include?(tag)
    end
  end

  private
  def create_slug
      self.slug = Russian::transliterate(self.title) if !self.slug
  end

end
