require 'rails_helper'

describe "Pass creation" do
  let(:rider) { FactoryGirl.create(:rider) }
  let(:payment) { FactoryGirl.create(:payment_detail, rider: rider) }

  context "POST /pass" do
    it "creates the pass using payment details" do
      body = api_post "/passes?rider_id=#{rider.id}&payment_detail_id=#{payment.id}&total_tickets=1&amount=2399"
      response.status.should == 200
      body['id'].should == Pass.last.id
      body['total_tickets'].should == 1
    end

    it "raises error if total_tickets not given on pass" do
      body = api_post "/passes?rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
      response.status.should == 400
      body['error']['message'].should == "Mandatory attributes missing: [:total_tickets, :amount]"
    end
  end

  context "GET /pass" do
    let(:pass) { FactoryGirl.create(:pass, rider: rider) }
    it "returns 404 if bad pass" do
      api_get "/passes/123?rider_id=#{rider.id}"
      response.status.should == 404
    end
    it "returns 404 if bad rider" do
      api_get "/passes/#{pass.id}?rider_id=123"
      response.status.should == 404
    end
    it "returns pass" do
      body = api_get "/passes/#{pass.id}?rider_id=#{rider.id}"
      response.status.should == 200
      body['id'].should == pass.id
    end
  end

  context "GET /passes" do
    let(:pass) { FactoryGirl.create(:pass, rider: rider)}
    it "returns 404 if bad rider" do
      api_get "/passes?rider_id=123"
      response.status.should == 404
    end
    it "returns passes" do
      pass
      body = api_get "/passes?rider_id=#{rider.id}"
      response.status.should == 200
      body.size.should == 1
    end
  end
end