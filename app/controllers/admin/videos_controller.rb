class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    video = Video.new(video_params)
    if video.save
      flash[:success] = "Video Added."
      redirect_to new_admin_video_path
    else
      @video = video
      flash[:error] = "Invalid Input."
      render :new
    end
  end

  private

  def require_admin
    flash[:error] = "You do not have administrative privileges." unless current_user.admin?
    redirect_to root_path unless current_user.admin?
  end

  def video_params
    params.require(:video).permit(:name, :description, :category_id, :small_cover, :large_cover)
  end
end
