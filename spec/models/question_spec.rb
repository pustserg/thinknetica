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
  let!(:question) { create(:question, user: user) }
  let!(:another_question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, best: true) }

  it { should have_many :answers }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many :tags }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }

  it { should  accept_nested_attributes_for :attachments}

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

  # describe 'has_best_answer and without_best_answer methods' do
  #   context 'has_best_answer' do
  #     it 'returns question with best answer' do
  #       expect(Question.has_best_answer.first).to eq question
  #     end
  #   end

  #   context 'not answered questions' do
  #     it 'returns question without best answer' do
  #       expect(Question.without_best_answer.first).to eq another_question
  #     end
  #   end
  # end

end
