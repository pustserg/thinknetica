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
  include VoteableModel

  has_many :answers, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :favorites
  has_many :subscribers, through: :favorites, source: :user
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  before_save :create_slug

  after_create do
    add_subscribers(self.user)
  end

  scope :answered, -> (answered){ where(answered: answered) }
  scope :today, -> { where("created_at >= ?", Time.zone.now.beginning_of_day ) }

  accepts_nested_attributes_for :attachments

  searchable do
    text :title, :stored => true
    text :body, :stored => true
  end

  def best_answer
    answers.where(best: true).first
  end

  def make_answered
    update(answered: true)
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

  def add_subscribers(user)
    self.subscribers << user unless self.subscribers.include?(user)
  end

  def send_new_answer_notification(answer)
    subscribers.find_each do |user|
      QuestionMailer.delay.new_answer(answer)
    end
  end

  private
  def create_slug
    self.slug = Russian::transliterate(self.title) if !self.slug
  end

end
