class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  private

  def not_permitted
    flash[:warning] = "Please Log In"
    redirect_to login_path
  end

  def require_user
    not_permitted unless logged_in?
  end
end
