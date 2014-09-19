class Location < ActiveRecord::Base
  has_and_belongs_to_many :routes
  acts_as_mappable distance_field_name: :distance

  # returns locations in the given radius
  scope :nearby_stops, lambda { |lat, lng, radius|
    # create the bounding box
    lat1 = lat - (radius / 69.0)
    lat2 = lat + (radius / 69.0)

    lng1 = lng - (radius / (69.0 * Math.cos(radians(lat))))
    lng2 = lng + (radius / (69.0 * Math.cos(radians(lat))))

    # This logic borrowed from http://www.plumislandmedia.net/mysql/haversine-mysql-nearest-loc/
    select("id, latitude, longitude,
            69 * DEGREES(ACOS(COS(RADIANS(#{lat}))
               * COS(RADIANS(locations.latitude))
               * COS(RADIANS(#{lng}) - RADIANS(locations.longitude))
               + SIN(RADIANS(#{lat}))
               * SIN(RADIANS(locations.latitude)))) AS distance_in_miles").
    where("latitude BETWEEN #{lat1} AND #{lat2} AND 
           longitude BETWEEN #{lng1} AND #{lng2}").
    order("distance_in_miles ASC")
  }

  def self.radians(degree)
    degree * Math::PI / 180
  end
end