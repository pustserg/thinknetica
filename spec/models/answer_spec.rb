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

require 'rails_helper'

RSpec.describe Answer, :type => :model do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:another_answer) { create(:answer, question: question) }

  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }

  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :question_id }

  it { should  accept_nested_attributes_for :attachments}

  describe 'make_best method' do
    it 'makes best attribute true' do
      answer.make_best

      expect(answer.best).to eq true
    end

    it 'makes question answeed true' do
      answer.make_best

      expect(answer.question.answered).to be true
    end

    it 'does not change question answered attribute when another answer becomes best' do
      answer.make_best
      another_answer.make_best

      expect(answer.question.answered).to eq true
    end
  end

  describe 'vote_up method' do
    it 'creates 1 like for answer' do
      expect{ answer.vote_up(user) }.to change(answer.votes.likes, :count).by(1)
    end
  end

  describe 'vote_down method' do
    it 'creates 1 dislike answer' do
      expect{ answer.vote_down(user) }.to change(answer.votes, :count).by(1)
    end
  end

end
