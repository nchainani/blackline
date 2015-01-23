class RouteRunSerializer < ActiveModel::Serializer
  attributes :id, :remaining_tickets, :run_datetime, :amount, :currency, :details, :bus

  attributes :run_datetime_local, :run_date_pretty, :run_datetime_pretty, :status, :lat, :lng

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

  has_one :bus
  def include_bus?
    # till some one comes with a use case for returning bus
    !@options[:no_bus]
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

  def status
    object.workflow_state
  end

  def lat
    object.route_run_location_updates.last.try(:lat)
  end

  def lng
    object.route_run_location_updates.last.try(:lng)
  end
end