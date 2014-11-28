class AdminsController < ApplicationController
  before_action :require_user
  before_action :require_admin

  private

  def require_admin
    flash[:error] = "You do not have administrative privileges." unless current_user.admin?
    redirect_to root_path unless current_user.admin?
  end
end
