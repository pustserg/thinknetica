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

require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { create(:user) }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }
  it { should have_many :authorizations }
  it { should have_many :favorites }

  context 'votes' do

    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:comment) { create(:question_comment, commentable: question, user: user) }
    
    before do
      question.vote_up(another_user)
      answer.vote_up(another_user)
      comment.vote_down(another_user)
    end
    
    describe 'user_votes' do
      it 'returns votes which user got for his questions/answers/comments' do
        expect(user.user_votes).to match(answer: answer.votes, question: question.votes, comment: comment.votes)
      end
    end

    describe 'likes' do
      it 'returns likes which user got for his questions/answers/comments' do
        expect(user.likes).to match(answer: answer.votes, question: question.votes, comment: [])
      end
    end

    describe 'dislikes' do
      it 'returns dislikes which user got for his questions/answers/comments' do
        expect(user.dislikes).to match(answer: [], question: [], comment: comment.votes)
      end
    end

  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    
    context 'user already has an authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        
        it 'does not create a new user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates new authorization for user' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1) 
        end

        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'new user' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@email.test' }) } 

        it 'does not create a new user' do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization for user with email and id' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

      end
    end
  end

  context 'mailer' do
    describe '.send dayly digest' do
      let!(:users) { create_list(:user, 2) }

      it 'should send dayly digest to all users' do
        users.each { |user| expect(QuestionMailer).to receive(:digest).with(user).and_call_original }
        User.send_daily_digest
      end
    end
  end

end
