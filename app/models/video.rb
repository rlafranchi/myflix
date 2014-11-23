class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> {order("created_at DESC")}
  validates_presence_of :name, :description

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_name(str)
    return [] if str.blank?
    where("name LIKE ?", "%#{str}%").order("created_at DESC")
  end
end
