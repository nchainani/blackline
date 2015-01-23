class TicketSerializer < ActiveModel::Serializer
  attributes :id, :status, :route_name, :amount, :currency, :uuid
  attributes :rider, :route_run, :location

  has_one :rider
  def include_rider?
    !@options[:no_rider]
  end

  has_one :route_run
  def include_route_run?
    !@options[:no_route_run]
  end

  def location
    if object.location
      { name: object.location.name,
        id: object.location.id,
        lat: object.location.lat,
        lng: object.location.lng,
        time: object.route_run.time_at_location(object.location)}
    else
      { name: "general" }
    end
  end

  def route_name
    object.route_run.route.name
  end
end