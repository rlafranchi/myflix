class User < ActiveRecord::Base
  include Tokenable
  validates_presence_of :email, :name, :password
  validates_uniqueness_of :email
  has_secure_password validations: false
  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order("list_order") }
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :invitations
  has_many :payments

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

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def deactivate!
    update_column(:active, false)
  end
end
