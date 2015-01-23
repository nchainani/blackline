require 'rails_helper'

describe "Route Run Controller spec" do
  let(:route_run) { FactoryGirl.create(:route_run) }
  let(:route) { route_run.route }

  it "route run is non_started by default" do
    route_run.workflow_state.should == "not_started"
  end

  context "#start" do
    it "updates the state as running" do
      body = api_post "/routes/#{route.id}/route_runs/#{route_run.id}/start"
      route_run.reload
      route_run.workflow_state.should == "running"
    end
  end

  context "#update_location" do
    before do
      route_run.start!
    end
    it "requires mandatory params" do
      body = api_post "/routes/#{route.id}/route_runs/#{route_run.id}/update_location"
      response.status.should == 400
      body['error']['message'].should == "Mandatory attributes missing: [:lat, :lng]"
    end
    it "updates lat and lng" do
      body = api_post "/routes/#{route.id}/route_runs/#{route_run.id}/update_location?lat=40.234234234&lng=-234.234234234"
      route_run.reload
      route_run.workflow_state.should == "running"
      route_run.route_run_location_updates.count.should == 1
      route_run.route_run_location_updates.first.lat.should == 40.234234234.to_d
      route_run.route_run_location_updates.first.lng.should == -234.234234234.to_d
      body = api_get "/routes/#{route.id}/route_runs/#{route_run.id}/location_status"
      body.should == {
        "status" => "running",
        "lat" => "40.234234234",
        "lng" => "-234.234234234"
      }
    end
  end

  context "#complete" do
    before do
      route_run.start!
    end
    it "completes the route run" do
      body = api_post "/routes/#{route.id}/route_runs/#{route_run.id}/complete"
      route_run.reload
      route_run.workflow_state.should == "complete"
    end
  end

  context "#location_status" do
    it "returns status" do
      body = api_get "/routes/#{route.id}/route_runs/#{route_run.id}/location_status"
      body.should == {
        "status" => "not_started",
        "lat" => nil,
        "lng" => nil
      }
    end
    it "returns last known location" do
      route_run.route_run_location_updates.create!(lat: 100, lng: 100)
      route_run.route_run_location_updates.create!(lat: 200, lng: 200)
      route_run.update_attributes!(workflow_state: "running")
      body = api_get "/routes/#{route.id}/route_runs/#{route_run.id}/location_status"
      body.should == {
        "status" => "running",
        "lat" => "200.0",
        "lng" => "200.0"
      }
    end
  end
end
