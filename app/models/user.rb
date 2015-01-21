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

  TEMP_EMAIL_REGEX = /.temp/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :confirmable

  USER_ACTIONS = ['questions', 'answers', 'comments']

  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :votes, dependent: :restrict_with_error
  has_many :authorizations, dependent: :destroy
  
  def karma
    likes.count - dislikes.count
  end

  def likes
    result = Vote.none
    USER_ACTIONS.each do |type|
      result += votes_for(type).likes
    end
    result.uniq
  end

  def dislikes
    result = Vote.none
    USER_ACTIONS.each do |type|
      result += votes_for(type).dislikes
    end
    result.uniq
  end

  def user_votes
    result = Vote.none
     USER_ACTIONS.each do |type|
      result += votes_for(type)
    end
    result.uniq
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info.email || "#{auth.uid}@#{auth.provider}.temp"
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0,20]
      if email !~ /.temp/
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save!
        user.create_authorization(auth)
      else
        user = User.new(email: email, password: password, password_confirmation: password)
        user.authorizations.new(provider: auth.provider, uid: auth.uid)
        # session[:user] = user
        # session[:user][:auth] = auth
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def check_code=(code)
    self.check_code = code
  end

  def check_code
    # Devise.friendly_token[0,20]
  end

  private
  def votes_for(type)
    Vote.joins("join #{type} on votes.voteable_id=#{type}.id").where("#{type}.user_id = ?", self.id)
  end

end
