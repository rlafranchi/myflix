class PasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.send_password_reset_email(user).deliver
      redirect_to password_confirmation_path
    else
      flash[:error] = ( params[:email].blank? ? "Email cannot be empty." : "Cannot find a user associated with that email.")
      render :new
    end
  end
end
