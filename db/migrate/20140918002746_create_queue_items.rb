class CreateQueueItems < ActiveRecord::Migration
  def change
    create_table :queue_items do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :list_order
      t.timestamps
    end
  end
end
