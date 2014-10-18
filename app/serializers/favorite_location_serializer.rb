class FavoriteLocationSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :latitude, :longitude
end