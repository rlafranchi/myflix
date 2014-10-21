class RemoveImageUrlColumnsFromVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :large_image_url
    remove_column :videos, :small_image_url
  end
end
