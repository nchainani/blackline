require 'rails_helper'

describe "Ticket creation" do
  let(:rider) { FactoryGirl.create(:rider) }
  let(:payment) { FactoryGirl.create(:payment_detail, rider: rider) }
  let(:pass) { FactoryGirl.create(:pass, rider: rider, total_tickets: 10) }
  let(:route_run) { FactoryGirl.create(:route_run) }

  context "POST /tickets" do
    it "makes the reservation using payment details" do
      available_seats = route_run.remaining_tickets
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
      response.status.should == 200
      route_run.reload.remaining_tickets.should == available_seats - 1
    end

    it "makes the reservation using pass" do
      available_tickets = pass.remaining_tickets
      available_seats = route_run.remaining_tickets
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&pass_id=#{pass.id}"
      response.status.should == 200
      route_run.reload.remaining_tickets.should == available_seats - 1
      pass.reload.remaining_tickets.should == available_tickets - 1
    end
  end

  context "POST /ticket errors" do
    it "422 for missing route_run or payment details" do
      api_post "/tickets?route_run_id=#{route_run.id}"
      response.status.should == 422
    end

    it "inactive payment" do
      payment.update_attributes!(active: false)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
      response.status.should == 422
    end
  end

  context "POST /tickets OUT OF SEATS" do
    it "error when no seats left on route_run" do
      route_run.update_attributes!(remaining_tickets: 0)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
      response.status.should == 410
    end
    it "error when no seats left on pass" do
      pass.update_attributes!(remaining_tickets: 0)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&pass_id=#{pass.id}"
      response.status.should == 410
    end
  end
end