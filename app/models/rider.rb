class Rider < ActiveRecord::Base
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  has_many :payment_details
  has_many :passes
  has_many :favorite_locations
  has_many :tickets
  has_many :authentications
end