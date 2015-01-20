class UserMailer < ActionMailer::Base
  default from: "admin@lvh.me"

  def change_email(user, email, check_code)
    @user = user
    @user.check_code = check_code
    mail(to: email, subject: 'Verify email')
  end

end
