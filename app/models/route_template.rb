class RouteTemplate < ActiveRecord::Base
  has_many :routes
  has_and_belongs_to_many :locations
end