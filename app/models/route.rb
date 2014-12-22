class Route < ActiveRecord::Base
  has_many :route_runs
  has_and_belongs_to_many :locations
  scope :active, -> { where(active: true) }

  # runs in the future (excludes past runs)
  def immediate_runs
    route_runs.where("run_datetime > '#{Time.now.utc}'").limit(10)
  end

  def self.find_nearby_routes(lat, lng, radius = 50, options = {})
    nearby_stops = Location.nearby_stops(lat, lng, radius)

    nearby_stops.joins(:routes).merge(Route.active).map(&:routes).flatten.uniq
    # Route.active.
    #   joins(:locations).merge(Location.where(id: nearby_stops.map(&:id))).all.uniq
  end
end