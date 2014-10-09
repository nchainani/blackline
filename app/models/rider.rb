class Rider < ActiveRecord::Base
  include BCrypt

  has_many :payment_details
  has_many :passes
  has_many :favorite_locations
  has_many :tickets
  has_many :authentications

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end