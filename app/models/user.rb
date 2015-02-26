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
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean          default(FALSE)
#  karma                  :integer          default(0)
#

class User < ActiveRecord::Base

  TEMP_EMAIL_REGEX = /.temp/
  USER_ACTIONS = ['question', 'answer', 'comment']

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :confirmable

  has_many :questions, dependent: :restrict_with_error
  has_many :answers, dependent: :restrict_with_error
  has_many :comments, dependent: :restrict_with_error
  has_many :votes, dependent: :restrict_with_error
  has_many :authorizations, dependent: :destroy
  has_many :favorites
  has_many :favorited_questions, through: :favorites, source: :question
  
  def likes
    result = {}
    USER_ACTIONS.each { |type| result[type.to_sym] = votes_for(type).likes }
    result
  end

  def dislikes
    result = {}
    USER_ACTIONS.each { |type| result[type.to_sym] = votes_for(type).dislikes }
    result
  end

  def user_votes
    result = {}
     USER_ACTIONS.each { |type| result[type.to_sym] = votes_for(type) }
    result
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
      if email !~ TEMP_EMAIL_REGEX
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save!
        user.create_authorization(auth)
      else
        user = User.new(email: email, password: password, password_confirmation: password)
        user.authorizations.new(provider: auth.provider, uid: auth.uid)
      end
    end
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def self.send_daily_digest
    find_each { |user| QuestionMailer.delay.digest(user) }
  end

  private

  def votes_for(type)
    many_form = type.pluralize(2)
    one_form = type.capitalize

    Vote.joins("join #{many_form} on (votes.voteable_id = #{many_form}.id AND votes.voteable_type = '#{one_form}')").where("#{many_form}.user_id=?", self.id)
  end

end
