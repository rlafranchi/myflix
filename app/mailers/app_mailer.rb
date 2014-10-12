class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Thanks for signing up"
  end
  def send_password_reset_email(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "MyFlix reset password"
  end
  def send_invitation_email(invitation)
    @user = invitation.user
    @invitation = invitation
    mail to: @invitation.email, from: @user.email, subject: "Sign up for MyFlix"
  end
end
