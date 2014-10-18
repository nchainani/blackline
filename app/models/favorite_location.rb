class FavoriteLocation < ActiveRecord::Base
  belongs_to :rider

  geocoded_by :description
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude, address: :description
  after_validation :reverse_geocode
end