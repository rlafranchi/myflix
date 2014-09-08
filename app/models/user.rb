class User < ActiveRecord::Base
  validates_presence_of :email, :name, :password
  validates_uniqueness_of :email
  has_secure_password validations: false
end