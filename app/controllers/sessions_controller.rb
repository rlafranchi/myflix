class SessionsController < ApplicationController
  def new
    redirect_to videos_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "Logged In"
      redirect_to videos_path
    else
      flash[:warning] = "There's something wrong with your username or password"
      redirect_to login_path
    end

  end

  def destroy
    session[:user_id] = nil
    flash[:warning] = "Logged Out"
    redirect_to root_path
  end
end
