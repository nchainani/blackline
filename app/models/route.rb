class Route < ActiveRecord::Base
  extend Enumerize
  has_many :route_runs
  has_and_belongs_to_many :locations
  scope :active, -> { where(active: true) }

  TIMEZONES = ActiveSupport::TimeZone.zones_map.keys
  enumerize :timezone, in: TIMEZONES

  # runs in the future (excludes past runs)
  def immediate_runs
    now = Time.now.utc
    uptil = now + 20.hours
    route_runs.where(run_datetime: now..uptil).limit(10)
  end

  def self.find_nearby_routes(lat, lng, radius = 50, options = {})
    nearby_stops = Location.nearby_stops(lat, lng, radius)

    nearby_stops.joins(:routes).merge(Route.active).map(&:routes).flatten.uniq
    # Route.active.
    #   joins(:locations).merge(Location.where(id: nearby_stops.map(&:id))).all.uniq
  end

  def today?(run)
    run.run_datetime.in_time_zone(self.timezone).to_date == Time.find_zone(self.timezone).today
  end
end