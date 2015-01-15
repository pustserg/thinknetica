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

require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, user: user, question: question) }
  let!(:comment) { create(:question_comment, commentable: question, user: user) }

  before do
    question.vote_up(another_user)
    answer.vote_up(another_user)
    comment.vote_down(another_user)
  end

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :votes }

  describe 'user_votes' do
    it 'returns votes which user got for his questions/answers/comments' do
      expect(user.user_votes).to match_array [question.votes.first, answer.votes.first, comment.votes.first]
    end
  end

  describe 'likes' do
    it 'returns likes which user got for his questions/answers/comments' do
      expect(user.likes).to match_array [question.votes.first, answer.votes.first]
    end
  end

  describe 'dislikes' do
    it 'returns dislikes which user got for his questions/answers/comments' do
      expect(user.dislikes).to match_array [comment.votes.first]
    end
  end

  describe 'karma' do
    it 'returns likes.count - dislikes.count' do
      expect(user.karma).to eq 1
    end
  end
end
