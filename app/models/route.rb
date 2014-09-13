class Route < ActiveRecord::Base
  belongs_to :route_template
  belongs_to :bus
  delegate :locations, to: :route_template

  # returns the routes around given lat and lng
  def self.find_nearby_routes(lat, lng, radius = 50, options = {})
    # find routes in the next 48 hours and that run near the user's location
    Route.where(run_datetime: Time.now..48.hours.from_now).
          joins(:route_template).
          merge(RouteTemplate.joins(:locations).
                merge(Location.nearby_stops(lat, lng, radius))).all
  end
end