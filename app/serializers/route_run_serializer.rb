class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_tickets, :run_datetime, :amount, :currency, :details, :bus

  attributes :run_datetime_local, :run_date_pretty, :run_datetime_pretty

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

  def run_datetime_local
    @local ||= object.run_datetime.in_time_zone(object.route.timezone)
  end

  def run_date_pretty
    # prints "December 19, 2014"
    run_datetime_local.strftime "%B %d, %Y"
  end

  def run_datetime_pretty
    # prints "December 19, 2014"
    run_datetime_local.strftime "%B %d, %Y - %H:%M %p"
  end
end