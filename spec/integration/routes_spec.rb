require 'rails_helper'

describe "Route Controller spec" do
  let(:route) { FactoryGirl.create(:route) }

  context "GET /routes" do
    it "returns the list of routes around the given lat, lng" do
      body = api_get "/routes?lat=#{route.locations.first.latitude}&lng=#{route.locations.first.longitude}&radius=50"
      response.status.should == 200
      body.count.should == 1
      puts body
    end

    it "returns empty list when no routes found" do
      body = api_get "/routes?lat=1.234243&lng=2.342342&radius=50"
      response.status.should == 200
      body.should == []
    end

  end
end