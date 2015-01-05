class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_tickets, :run_datetime, :amount, :currency, :details, :bus

  attributes :run_date_pretty, :run_datetime_pretty

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

  def run_date_pretty
    # prints "December 19, 2014"
    in_local_time.strftime "%B %d, %Y"
  end

  def run_datetime_pretty
    # prints "December 19, 2014"
    in_local_time.strftime "%B %d, %Y - %H:%M %p"
  end

  def bus
    BusSerializer.new(object.bus)
  end

  private

  def in_local_time
    object.run_datetime.in_time_zone(object.route.timezone)
  end
end