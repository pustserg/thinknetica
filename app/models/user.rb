# -*- encoding : utf-8 -*-
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  USER_ACTIONS = ['questions', 'answers', 'comments']

  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :votes, dependent: :restrict_with_error
  
  def karma
    likes.count - dislikes.count
  end

  def likes
    result = Vote.none
    USER_ACTIONS.each do |type|
      result += votes_for(type).likes
    end
    result
  end

  def dislikes
    result = Vote.none
    USER_ACTIONS.each do |type|
      result += votes_for(type).dislikes
    end
    result
  end

  def user_votes
    result = Vote.none
     USER_ACTIONS.each do |type|
      result += votes_for(type)
    end
    result
  end

  private
  def votes_for(type)
    Vote.joins("join #{type} on votes.voteable_id=#{type}.id").where("#{type}.user_id = ?", self.id)
  end

end
