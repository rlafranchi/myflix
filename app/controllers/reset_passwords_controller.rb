class ResetPasswordsController < ApplicationController
  def show
    @token = params[:id]
    user = User.find_by(token: @token)
    if user
      render :show
    else
      redirect_to expired_token_path
    end
  end

  def create
    user = User.find_by(token: reset_password_params[:token])
    user.password = reset_password_params[:password]
    if user.save
      user.generate_token
      user.save
      flash[:success] = "Password updated."
      redirect_to login_path
    else
      flash[:error] = "Invalid input."
      render :show
    end
  end

  private

  def reset_password_params
    params.permit!
  end
end
