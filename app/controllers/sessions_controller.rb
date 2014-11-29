class SessionsController < ApplicationController
  def new
    redirect_to videos_path if current_user
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "Logged In"
        redirect_to videos_path
      else
        flash[:error] = "Your account is suspended. Please contact customer service"
        redirect_to login_path
      end
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
