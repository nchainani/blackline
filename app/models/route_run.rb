class RouteRun < ActiveRecord::Base
  belongs_to :route
  belongs_to :bus
  delegate :locations, to: :route

  validate :locations_and_times_match

  def locations_and_times_match
    if times.to_s.split(",").count != locations.count
      errors.add(:location_and_time_mismatch, "The route has different number of locations and times")
    end
  end
end