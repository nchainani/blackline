require 'rails_helper'

describe "Payment detail creation" do
  let(:rider) { FactoryGirl.create(:rider) }

  context "POST /payment_details" do
    it "creates the payment detail" do
      Stripe::Customer.should_receive(:create).with(card: "tknsadf234234234", description: rider.email).and_return(double('stripe customer', id: "cus_1242323"))
      body = api_post "/payment_details?rider_id=#{rider.id}&last4=1234&card_type=MASTER_CARD&token=tknsadf234234234"
      response.status.should == 200
      rider.payment_details.count.should == 1
      payment = rider.payment_details.last
      payment.card_type.should == "MASTER_CARD"
      payment.last4.should == "1234"
      payment.token.should == "tknsadf234234234"
    end
  end
#
#     it "raises error if total_tickets not given on pass" do
#       body = api_post "/passes?rider_id=#{rider.id}&payment_detail_id=#{payment.id}"
#       response.status.should == 400
#       body['error']['message'].should == "Mandatory attributes missing: [:total_tickets]"
#     end
#   end
#
#   context "GET /pass" do
#     let(:pass) { FactoryGirl.create(:pass, rider: rider) }
#     it "returns 404 if bad pass" do
#       api_get "/passes/123?rider_id=#{rider.id}"
#       response.status.should == 404
#     end
#     it "returns 404 if bad rider" do
#       api_get "/passes/#{pass.id}?rider_id=123"
#       response.status.should == 404
#     end
#     it "returns pass" do
#       body = api_get "/passes/#{pass.id}?rider_id=#{rider.id}"
#       response.status.should == 200
#       body['id'].should == pass.id
#     end
#   end
#
#   context "GET /passes" do
#     let(:pass) { FactoryGirl.create(:pass, rider: rider)}
#     it "returns 404 if bad rider" do
#       api_get "/passes?rider_id=123"
#       response.status.should == 404
#     end
#     it "returns passes" do
#       pass
#       body = api_get "/passes?rider_id=#{rider.id}"
#       response.status.should == 200
#       body.size.should == 1
#     end
#   end
end