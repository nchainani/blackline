require 'rails_helper'

describe "Pass plan index" do
  let(:pass_plan) { FactoryGirl.create(:pass_plan) }
  let(:pass_plan_inactive) { FactoryGirl.create(:pass_plan, active: false) }

  context "GET /pass_plans" do
    it "returns pass_plans" do
      pass_plan
      pass_plan_inactive
      body = api_get "/pass_plans"
      response.status.should == 200
      body.size.should == 1
      plan = body.first
      plan['id'].should == pass_plan.id
      plan['name'].should == pass_plan.name
    end
  end

  context "GET /pass_plans/:id" do
    it "returns pass_plans" do
      body = api_get "/pass_plans/#{pass_plan_inactive.id}"
      response.status.should == 200
      body['id'].should == pass_plan_inactive.id
      body['name'].should == pass_plan_inactive.name
    end
  end
end