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
  
  def calculate_karma
    
    # Если пользователь первым ответил на свой вопрос, то он получает +3 балл к рейтингу
    

    likes_sum = 0
    # При ответе на вопрос у пользователя увеличиватеся рейтинг на 1 балл
    likes_sum += answers.count
    # За каждый голос “за” к вопросу пользователя, пользователь получает +2 балла к рейтингу
    likes_sum += 2 * likes[:question].count
    # За каждый голос “за” к ответу пользователя, пользователь получает +1 балл к рейтингу
    likes_sum += likes[:answer].count
    
    answers.each do |answer|
      # Если ответ пользователя признан “лучшим”, то пользователь получает +3 балла к рейтингу
      likes_sum += 3 if answer.best?
      # Если пользователь первым ответил на вопрос, то он получает +1 балл к рейтингу
      likes_sum += 1 if answer.question.first_answer == answer
      # Если пользователь ответил на свой вопрос, но не был первым, то он поулчает +2 балла к рейтингу.
      likes_sum += 2 if answer.question.user == self
    end
    


    dislikes_sum = 0
    # За каждый голос “против” к вопросу пользователя, пользователь получает -2 балла к рейтингу
    dislikes_sum += 2 * dislikes[:question].count
    # За каждый голос “против” к ответу пользователя, пользователь получает -1 балл к рейтингу
    dislikes_sum += dislikes[:answer].count

    self.update(karma: likes_sum - dislikes_sum)
  end

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
