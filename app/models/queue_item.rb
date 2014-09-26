class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :name, to: :video, prefix: :video

  validates_numericality_of :list_order, {only_integer: true}

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating.to_i if review
  end

  def category_name
    category.name
  end

  def self.queue_video(video)
    self.create(video: video, user: User.current_user, list_order: User.current_user.new_qitem_order) unless User.current_user.queued_video?(video)
  end
end
