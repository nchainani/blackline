class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_tickets, :run_datetime, :details, :bus

  def details
    times = object.times.split(",")
    array = []
    object.locations.each_with_index do |location, index|
      array << {
        id: location.id,
        lat: location.lat,
        lng: location.lng,
        direction: location.direction,
        name: location.name,
        time: times[index]
      }
    end
    array
  end

  def bus
    BusSerializer.new(object.bus)
  end
end
