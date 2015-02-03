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
#  answered   :boolean          default(FALSE)
#

require 'rails_helper'

RSpec.describe Question, :type => :model do
  
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:another_question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, best: true) }
  let!(:another_answer) { create(:answer, question: question, best: true) }

  it { should have_many :answers }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many :tags }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should  accept_nested_attributes_for :attachments}

  describe 'best answer method' do
    it 'returns only 1 record' do
      answer.make_best
      another_answer.make_best

      expect(question.best_answer).to eq another_answer
    end
  end

  describe 'make answered method' do
    it 'updates answered attribute' do
      question.make_answered

      expect(question.answered).to eq true
    end
  end

  describe 'vote_up method' do
    it 'creates 1 like for question' do
      expect{ question.vote_up(user) }.to change(question.votes.likes, :count).by(1)
    end
  end

  describe 'vote_down method' do
    it 'creates 1 dislike for question' do
      expect{ question.vote_down(user) }.to change(question.votes.dislikes, :count).by(1)
    end
  end

  describe "tag_list method" do
    it 'tag_list returns tags names' do
      question.tags.create(name: "first")
      question.tags.create(name: "second")

      expect(question.tag_list).to eq 'first, second'
    end
  end

  describe 'tag_list= method' do
    it 'creates Tag model records' do
      expect{ question.tag_list=("first, second, first") }.to change(question.tags, :count).by(2)
    end

    it 'does not creates new tag if tag was created early' do
      question.tag_list=("first, second")

      expect{ another_question.tag_list=("first") }.to_not change(Tag, :count)
    end
  end

  describe 'add subscribers method' do
    
    it 'adds user to question subscribers' do
      expect{ question.add_subscribers(another_user) }.to change(question.subscribers, :count).by(1)
    end

    it 'question author must be in subscribers' do
      expect(question.subscribers).to include(question.user)
    end

  end

  describe 'send subscribers notification after creating answer' do
    
    it 'should send new answer notification to all subscribers' do
      expect(QuestionMailer).to receive(:new_answer).with(question.user)
      question.answers.create!(body: "answer", user: user)
    end

  end

end
