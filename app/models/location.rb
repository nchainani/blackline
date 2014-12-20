class Location < ActiveRecord::Base
  has_and_belongs_to_many :routes

  # returns locations in the given radius
  scope :nearby_stops, lambda { |latitude, longitude, radius|
    # create the bounding box
    lat1 = latitude - (radius / 69.0)
    lat2 = latitude + (radius / 69.0)

    lng1 = longitude - (radius / (69.0 * Math.cos(radians(latitude))))
    lng2 = longitude + (radius / (69.0 * Math.cos(radians(latitude))))

    # This logic borrowed from http://www.plumislandmedia.net/mysql/haversine-mysql-nearest-loc/
    select("locations.id, lat, lng,
            69 * DEGREES(ACOS(COS(RADIANS(#{latitude}))
               * COS(RADIANS(locations.lat))
               * COS(RADIANS(#{longitude}) - RADIANS(locations.lng))
               + SIN(RADIANS(#{latitude}))
               * SIN(RADIANS(locations.lat)))) AS distance_in_miles").
    where("lat BETWEEN #{lat1} AND #{lat2} AND
           lng BETWEEN #{lng1} AND #{lng2}").
    order("distance_in_miles ASC")
  }

  def self.radians(degree)
    degree * Math::PI / 180
  end
end