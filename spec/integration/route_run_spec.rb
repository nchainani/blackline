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
      route_run.lat.should == 40.234234234
      route_run.lng.should == -234.234234234
      route_run.workflow_state.should == "running"
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
end
