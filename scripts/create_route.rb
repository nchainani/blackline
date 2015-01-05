require 'json'
require 'httparty'

class CreateRoute
  attr_accessor :origin, :destination, :waypoints

  def perform(locations)
    raise "location count should be > 1" if locations.count <= 1
    self.origin = locations.slice!(0)
    self.destination = locations.slice!(-1)
    self.waypoints = locations
    routes = Directions.new.call(origin, destination, waypoints)
  end
end

class Directions

  def call(origin, destination, waypoints = [])
    url = "http://maps.googleapis.com/maps/api/directions/json"
    params = {origin: origin, destination: destination}
    if waypoints && !waypoints.empty?
      str = "via:" + waypoints.join("|via:")
      params[:waypoints] =  str
    end
    response = JSON.parse(make_request(url, params))
    response['routes'].map do |route|
      leg = route['legs'].first
      {
        name: route['summary'],
        polyline: route['overview_polyline']['points'],
        #complex_polyline: leg['steps'].map {|step| step['polyline']['points']}.join(""),
        box: [ p2a(route['bounds']['northeast']), p2a(route['bounds']['southwest']) ],
        origin: p2a(leg['start_location']),
        destination: p2a(leg['end_location']),
        points: leg['via_waypoint'].map {|point| p2a(point['location'])}
      }
    end
  end

  def make_request(url, params)
    puts params
    HTTParty.get(url, query: params).body
  end

  def p2a(point)
    [point['lat'], point['lng']]
  end
end

locations = []
locations << "3206 North Halsted Street, Chicago, IL"
locations << "2800 North Halsted Street, Chicago, IL"
locations << "2384 N Lincoln Ave, Chicago, IL"
locations << "2012 North Larrabee Street, Chicago, IL 60614,"
locations << "1600 North Larrabee Street, Chicago, IL 60614, USA"
locations << "800 North Larrabee Street, Chicago, IL 60654"

bus = Bus.create!(capacity: 38, bus_type: "bus", owner: "M and M", registration_number: "234234")
route.route_runs.create!(bus_id: bus.id, run_datetime: Time.parse("2015-01-05 13:30:00"), amount: 1.99, currency: :USD, times: "7:30,7:33,7:37,7:44,7:48,7:55")