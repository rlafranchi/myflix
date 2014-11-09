class VideoDecorator < Draper::Decorator
  delegate_all

  def average_rating
    sum = 0.0
    video.reviews.all.each do |rev|
      sum += rev.rating.to_i
    end
    if reviews.count != 0
      (sum.to_f / reviews.all.count.to_f).round(1)
    else
      " - "
    end
  end
end
