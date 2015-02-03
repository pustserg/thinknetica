class QuestionMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_mailer.digest.subject
  #
  def digest(user)
    @greeting = "Hi"

    mail to: user.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_mailer.new_answer.subject
  #
  def new_answer
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
