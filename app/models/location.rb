class Location < ActiveRecord::Base
  has_and_belongs_to_many :route_templates
end