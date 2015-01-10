require 'rails_helper'

describe "Ticket creation" do
  let(:rider) { FactoryGirl.create(:rider) }
  let(:payment) { FactoryGirl.create(:payment_detail, rider: rider) }
  let(:pass) { FactoryGirl.create(:pass, rider: rider, total_tickets: 10) }
  let(:route_run) { FactoryGirl.create(:route_run) }

  context "POST /tickets" do
    it "makes the reservation using payment details" do
      available_seats = route_run.remaining_tickets
      expect(Stripe::Charge).to receive(:create).with({ amount: 199, currency: "USD", customer: payment.customer_id })
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}&amount=199"
      response.status.should == 200
      route_run.reload.remaining_tickets.should == available_seats - 1
    end

    it "makes the reservation using pass" do
      available_tickets = pass.remaining_tickets
      available_seats = route_run.remaining_tickets
      expect(Stripe::Charge).to_not receive(:create)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&pass_id=#{pass.id}&amount=199"
      response.status.should == 200
      route_run.reload.remaining_tickets.should == available_seats - 1
      pass.reload.remaining_tickets.should == available_tickets - 1
      pass.status.should_not == :complete
    end

    it "marks the pass as complete when remaining_tickets are down to 0" do
      pass.update_attributes!(remaining_tickets: 1)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&pass_id=#{pass.id}&amount=199"
      response.status.should == 200
      pass.reload.status.should == "complete"
    end
  end

  context "POST /ticket errors" do
    it "404 for missing route_run or payment details" do
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&amount=199"
      response.status.should == 404
    end

    it "inactive payment" do
      payment.update_attributes!(active: false)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}&amount=199"
      response.status.should == 422
    end
  end

  context "POST /tickets OUT OF SEATS" do
    it "error when no seats left on route_run" do
      route_run.update_attributes!(remaining_tickets: 0)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&payment_detail_id=#{payment.id}&amount=199"
      response.status.should == 410
    end
    it "error when no seats left on pass" do
      pass.update_attributes!(remaining_tickets: 0)
      api_post "/tickets?route_run_id=#{route_run.id}&rider_id=#{rider.id}&pass_id=#{pass.id}&amount=199"
      response.status.should == 410
    end
  end

  context "GET /tickets/:id" do
    let(:ticket) { FactoryGirl.create(:ticket, rider: rider) }
    it "returns 404 if bad ticket" do
      api_get "/tickets/123?rider_id=#{rider.id}"
      response.status.should == 404
    end
    it "returns 404 if bad rider" do
      api_get "/tickets/#{ticket.id}?rider_id=123"
      response.status.should == 404
    end
    it "returns ticket" do
      body = api_get "/tickets/#{ticket.id}?rider_id=#{rider.id}"
      response.status.should == 200
      body['id'].should == ticket.id
    end
    it "returns ticket's image" do
      body = get "/api/v1/tickets/#{ticket.id}/smallImage?rider_id=#{rider.id}", nil, 'HTTP_BLACKLINE_CLIENT_TOKEN' => 'test_key'
      response.status.should == 200
      response.headers["Content-Type"].should == "application/octet-stream"
    end
  end

  context "GET /tickets" do
    let(:ticket) { FactoryGirl.create(:ticket, rider: rider)}
    it "returns 404 if bad rider" do
      api_get "/tickets?rider_id=123"
      response.status.should == 404
    end
    it "returns tickets" do
      ticket
      body = api_get "/tickets?rider_id=#{rider.id}&status=#{ticket.status}"
      response.status.should == 200
      body.size.should == 1
    end
  end
end