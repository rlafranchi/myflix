class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Thanks for signing up"
  end
  def send_password_reset_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "MuyFlix reset password"
  end
end
