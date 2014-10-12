class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :user
  validates_presence_of :email, :name, :message
  validates_uniqueness_of :email
end
