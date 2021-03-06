class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_name(params[:search_term])
  end
end
