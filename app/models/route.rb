class Route < ActiveRecord::Base
  belongs_to :route
  belongs_to :bus
end