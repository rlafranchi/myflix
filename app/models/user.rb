class User < ActiveRecord::Base
  validates_presence_of :email, :name, :password
  validates_uniqueness_of :email
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> { order("list_order") }

  def normalize_queue_items
    queue_items.each_with_index do |qitem, i|
      qitem.update_attributes(list_order: i + 1)
    end
  end

  def new_qitem_order
    queue_items.count + 1
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def queue_items_present?
    queue_items.any?
  end
end
