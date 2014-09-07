class Video < ActiveRecord::Base
  has_many :video_categories
  has_many :categories, through: :video_categories
  validates_presence_of :name, :description

  def self.search_by_name(str)
    return [] if str.blank?
    where("name LIKE ?", "%#{str}%").order("created_at DESC")
  end
end
