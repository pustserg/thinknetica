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
  before_validation :create_slug

  validates :title, :body, :user_id, :slug, presence: true

  has_many :answers
  has_many :comments, as: :commentable
  has_many :attachments, as: :attachmentable 
  has_many :votes, as: :voteable
  belongs_to :user

  accepts_nested_attributes_for :attachments

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
    "#{id}_#{title}".parameterize
  end

  def create_slug
      self.slug = self.title if !self.slug
  end

end
