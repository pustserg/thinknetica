require 'rails_helper'

describe Ability do

  CLASSES = [Question, Answer, Comment, Vote]
  CLASS_OBJECTS = [:question, :answer, :question_comment]
  subject(:ability) { Ability.new(user) }

  describe 'guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:another_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    CLASSES.each do |cl|
      it { should be_able_to :create, cl }
    end

    [:edit, :update, :destroy].each do |action|
      CLASS_OBJECTS.each do |object|
        it { should be_able_to action, create(object, user: user), user: user }
        it { should_not be_able_to action, create(object, user: another_user), user: user }
      end
    end

    CLASS_OBJECTS.each do |object|
      it { should be_able_to :vote_up, create(object, user: another_user), user: user }
      it { should be_able_to :vote_down, create(object, user: another_user), user: user }

      it { should_not be_able_to :vote_up, create(object, user: user), user: user }
      it { should_not be_able_to :vote_down, create(object, user: user), user: user }
    end

    it { should be_able_to :make_best, create(:answer, question: create(:question, user: user)), user: user }
    it { should_not be_able_to :make_best, create(:answer, question: create(:question, user: another_user)), user: user }

  end
end
