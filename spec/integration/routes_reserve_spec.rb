require 'rails_helper'

describe "Reserve route run" do
  let(:rider) { FactoryGirl.create(:rider) }
  let(:payment) { FactoryGirl.create(:payment_detail, rider: rider) }
  let(:route_run) { FactoryGirl.create(:route_run) }

  context "PUT /reserve" do
    it "422 for missing route_run or payment details" do
      api_put "/routes/#{route_run.route.id}/route_runs/#{route_run.id}/reserve"
      response.status.should == 422
    end

    it "makes the reservation using payment details" do
      api_put "/routes/#{route_run.route.id}/route_runs/#{route_run.id}/reserve?rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
      puts response.body
      response.status.should == 200
    end
  end
end