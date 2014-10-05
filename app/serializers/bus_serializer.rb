class BusSerializer < ActiveModel::Serializer
  attributes :id, :capacity, :bus_type, :registration_number 
end