require 'rails_helper'

RSpec.describe KarmaCalculator, :type => :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  describe 'calculate' do
    context 'when user creates answer (not first answer) he gets +1 karma' do
      let(:question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }
      let!(:answer) { create(:answer, user: user, question: question) }
      it 'should return 1' do
        expect{ calc(user) }.to change(user, :karma).by(1)
      end
    end

    context "when user's question get vote +, user gets +2 karma" do
      let(:question) { create(:question, user: user) }
      before { question.votes.create!(user: another_user, status: '+') }
      it 'should change user karma by 2' do
        expect{ calc(user) }.to change(user, :karma).by(2)
      end
    end

    context "when user's answer get vote +, user gets +1 karma" do
      let(:question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }
      let!(:answer) { create(:answer, user: user, question: question) }
      before { answer.votes.create!(user: another_user, status: '+') }

      it 'should change user karma by 1+2' do
        expect{ calc(user) }.to change(user, :karma).by(2)
      end
    end

    context "when user's question gets vote -, user gets -2 karma" do
      let(:question) { create(:question, user: user) }
      before { question.votes.create(user: another_user, status: '-') }

      it 'should change user karma by -2' do
        expect{ calc(user) }.to change(user, :karma).by(-2)
      end
    end

    context "when user's answer gets vote -, user gets -1 karma" do
      let(:question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }
      let!(:answer) { create(:answer, user: user, question: question) }
      let!(:else_answer) { create(:answer, user: user, question: question) }
      before { answer.votes.create!(user: another_user, status: '-') }

      it 'should change user karma by 1 + 1 - 1 = 1' do
        expect{ calc(user) }.to change(user, :karma).by(1)
      end
    end

    context "when user's answer marked as best, user gets +3 karma" do
      let(:question) { create(:question, user: another_user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }
      let!(:answer) { create(:answer, user: user, question: question) }
      before { answer.make_best }

      it "should change user karma by 1 + 3" do
        expect{ calc(user) }.to change(user, :karma).by(4)
      end
    end

    context "if user's answer is the first, he gets +1 karma" do
      let(:question) { create(:question, user: another_user) }
      let!(:answer) { create(:answer, user: user, question: question) }

      it 'should change user karma by 1 + 1' do
        expect{ calc(user) }.to change(user, :karma).by(2)
      end
    end

    context "if user's answer is the first and answer is for user's question, he gets +3 karma" do
      let(:question) { create(:question, user: user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'should change user karma by 3' do
        expect{ calc(user) }.to change(user, :karma).by(3)
      end
    end

    context "if user answers for his question, but not first, he gets +2 karma" do
      let(:question) { create(:question, user: user) }
      let!(:another_answer) { create(:answer, question: question, user: another_user) }
      let!(:answer) { create(:answer, question: question, user: user) }

      it 'should change user karma by 2' do
        expect{ calc(user) }.to change(user, :karma).by(2)
      end
    end

    def calc(user)
      KarmaCalculator::calculate(user)
    end
  end

end