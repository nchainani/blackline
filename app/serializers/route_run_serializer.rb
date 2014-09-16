class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_tickets, :details

  def details
    times = object.times.split(",")
    array = []
    object.locations.each_with_index do |location, index|
      array << {
        lat: location.latitude,
        lng: location.longitude,
        id: location.id,
        name: location.name,
        time: times[index]
      }
    end
    array
  end
end
