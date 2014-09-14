class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_seats, :details

  def remaining_seats
    object.total_seats - Ticket.where(route_run_id: object.id).count
  end

  def details
    times = object.times.split(",")
    array = []
    object.locations.each_with_index do |location, index|
      array << {
        lat: location.latitude,
        lng: location.longitude,
        name: location.name,
        time: times[index]
      }
    end
    array
  end
end
