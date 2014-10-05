require 'rails_helper'

describe "Route Controller spec" do
  let(:route_run) { FactoryGirl.create(:route_run) }
  let(:route) { route_run.route }

  context "GET /routes" do

    context "no routes in the given radius around lat, lng" do
      it "returns an empty list" do
        route_run
        body = api_get "/routes?lat=1.234243&lng=2.342342&radius=50"
        response.status.should == 200
        body.should == []
      end
    end

    context "routes exist in the given radius around lat, lng" do
      it "returns the list of routes with their run times" do
        body = api_get "/routes?lat=#{route.locations.first.lat}&lng=#{route.locations.first.lng}&radius=50"
        response.status.should == 200
        body.count.should == 1
        verify_route(body.first, route)
        body.first['runs'].count.should == 1
        verify_route_run(body.first['runs'].first, route_run)
      end
    end

    context "excludes older route runs" do
      before do
        @old_route_run = FactoryGirl.create(:route_run, route: route, run_datetime: 10.days.ago)
      end
      it "returns the list of routes with their run times" do
        body = api_get "/routes?lat=#{route.locations.first.lat}&lng=#{route.locations.first.lng}&radius=50"
        response.status.should == 200
        body.count.should == 1
        verify_route(body.first, route)
        body.first['runs'].count.should == 1
        body.first['runs'].map{|run| run['id']}.should_not include(@old_route_run.id)
        verify_route_run(body.first['runs'].first, route_run)
      end
    end
  end

  context "GET /routes/:id" do
    it "404 if a route does not exist" do
      api_get "/routes/1010101"
      response.status.should == 404
    end

    it "clients can ask for a specific route" do
      body = api_get "/routes/#{route.id}"
      verify_route(body, route)
    end
  end

  context "GET /routes/:id/route_runs/:id" do
    it "404 if a route_run does not exist" do
      api_get "/routes/#{route.id}/route_runs/1010101"
      response.status.should == 404
    end
    it "can ask for specific route run" do
      body = api_get "/routes/#{route.id}/route_runs/#{route_run.id}"
      verify_route_run(body, route_run)
    end
  end

  def verify_route(route_in_response, route)
    route_in_response['id'].should == route.id
    route_in_response['direction'].should == route.direction
    route_in_response['description'].should == route.description
    route_in_response['polyline'].should == route.polyline
  end

  def verify_route_run(route_run_in_response, route_run)
    route_run_in_response['id'].should == route_run.id
    route_run_in_response['remaining_tickets'].should == route_run.total_tickets - Ticket.where(route_run_id: route_run.id).count
    route_run_in_response['details'].count.should == route_run.locations.count
    route_run_in_response['details'].each_with_index do |detail, index|
      location = route_run.locations[index]
      time = route_run.times.split(",")[index]
      detail['lat'].should == location.lat.to_s
      detail['lng'].should == location.lng.to_s
      detail['name'].should == location.name
      detail['time'].should == time
    end
    bus = route_run_in_response['bus']
    bus['id'] = route_run.bus.id
    bus['capacity'] = route_run.bus.capacity
    bus['bus_type'] = route_run.bus.bus_type
    bus['registration_number'] = route_run.bus.registration_number
  end
end