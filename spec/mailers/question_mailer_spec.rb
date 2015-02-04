require "rails_helper"

RSpec.describe QuestionMailer, :type => :mailer do
  let(:user) { create(:user) }
  
  describe "digest" do
    let(:mail) { QuestionMailer.digest(user) }
    let!(:questions) { create_list(:question, 2) }

    it "renders the headers" do
      expect(mail.subject).to eq("Digest")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(/#{questions[1].title}/)
      expect(mail.body.encoded).to match(/#{questions[0].title}/)
    end
  end

  describe "new_answer" do
    let(:answer) { create(:answer, question: create(:question)) }
    let(:mail) { QuestionMailer.new_answer(user, answer.question) }
  
    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(/#{answer.question.title}/)
    end
  end

end
