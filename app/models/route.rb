class Route < ActiveRecord::Base
  belongs_to :route_template
  belongs_to :bus
end