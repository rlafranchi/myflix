class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    review_params[:rating] = review_params["rating"[0].to_i]
    review = Review.new(review_params)
    review.user_id = current_user.id
    if review.save
      @video.reviews << review
      redirect_to @video
    else
      @review = @video.reviews.reload
      render 'videos/show'
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
