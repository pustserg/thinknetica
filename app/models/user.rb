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

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :votes
  
  def karma
    likes_count - dislikes_count
  end

  def likes_count
    result = 0
    USER_ACTIONS.each do |type|
      result += votes_for(type).likes.count
    end
    result
  end

  def dislikes_count
    result = 0
    USER_ACTIONS.each do |type|
      result += votes_for(type).dislikes.count
    end
    result
  end

  private
  def votes_for(type)
    Vote.joins("join #{type} on votes.voteable_id=#{type}.id").where("#{type}.user_id = ?", self.id)
  end

end
