class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}
  validates_presence_of :name, :description

  def self.search_by_name(str)
    return [] if str.blank?
    where("name LIKE ?", "%#{str}%").order("created_at DESC")
  end

  def average_rating
    sum = 0.0
    reviews.all.each do |rev|
      sum += rev.rating.to_i
    end
    if reviews.count != 0
      (sum.to_f / reviews.all.count.to_f).round(1)
    else
      " - "
    end
  end
end
