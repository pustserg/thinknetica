# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  body        :text
#  created_at  :datetime
#  updated_at  :datetime
#  question_id :integer
#  user_id     :integer
#  best        :boolean          default(FALSE)
#

class Answer < ActiveRecord::Base
  include VoteableModel

  belongs_to :question
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments
  after_save :send_notification


  def make_best
    if question.best_answer.nil?
      question.make_answered
      update(best: true)
    elsif question.best_answer != self
      question.best_answer.update(best: false)
      update(best: true)
    end
  end

  private

  def send_notification
    question.delay.send_new_answer_notification
  end

end
