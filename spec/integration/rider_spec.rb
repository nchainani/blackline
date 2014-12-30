require 'rails_helper'

describe "Rider spec" do
  context "#registration" do
    it "allows registering a new rider" do
      body = api_post "/riders?name=john&email=john.doe123@gmail.com&password=abcdefghi"
      response.status.should == 201
      Rider.count.should == 1
      body['id'].should == Rider.last.id
      body['name'].should == "john"
      body['email'].should == "john.doe123@gmail.com"
      body['authentication_token'].should_not be_nil
    end

    it "requires mandatory params" do
      body = api_post "/riders?name=john&password=abcdefghi"
      response.status.should == 400
      body['error'].should == {"httpCode"=>400, "message"=>"Mandatory attributes missing: [:email]"}

      body = api_post "/riders?first_name=john&last_name=doe&email=john.doe123@gmail.com"
      response.status.should == 400
      body['error'].should == {"httpCode"=>400, "message"=>"Mandatory attributes missing: [:name, :password]"}
    end
  end

  context "#login" do
    it "allows user to sign in using username and password" do
      body = api_post "/riders/login"
      response.status.should == 422

      body = api_post "/riders/login?email=something@test.com"
      response.status.should == 422

      user = create_user
      body = api_post "/riders/login?password=xxx&rider_email=#{user['email']}"
      response.status.should == 401

      body = api_post "/riders/login?password=abcdefghi&rider_email=#{user['email']}"
      response.status.should == 200
      body['id'].should_not be_nil
    end
  end

  context "token authentication" do
    it "let's user authenticate using token" do
      user = create_user
      puts "/tickets?rider_email=#{user['email']}&rider_token=#{user['authentication_token']}"
      api_get "/tickets?rider_email=#{user['email']}&rider_token=#{user['authentication_token']}"
      response.status.should == 200
    end
  end

  context "#update_password" do
    it "allows user to reset their password"
  end

  context "#logout" do
    it "changes the token"
  end

  context "#destroy" do
    it "deletes the user (this probably should just be a boolean)"
  end

  context '#suggestedPaymentMethod' do
    let(:rider) { create_user }
    let(:pass) { FactoryGirl.create(:pass, rider: Rider.find(rider['id'])) }
    let(:payment_detail) { FactoryGirl.create(:payment_detail, rider: Rider.find(rider['id'])) }
    it "returns empty when nothing available" do
      rider = create_user
      body = api_get "/riders/suggested_payment_method?rider_email=#{rider['email']}&rider_token=#{rider['authentication_token']}"
      body.should == {}
    end
    it "returns pass when available" do
      pass
      body = api_get "/riders/suggested_payment_method?rider_email=#{rider['email']}&rider_token=#{rider['authentication_token']}"
      body['type'].should == 'pass'
      body['id'].should == pass.id
    end
    it "returns payment details when no pass available" do
      payment_detail
      body = api_get "/riders/suggested_payment_method?rider_email=#{rider['email']}&rider_token=#{rider['authentication_token']}"
      body['type'].should == 'payment_detail'
      body['id'].should == payment_detail.id
    end
  end

  def create_user
    api_post "/riders?name=doe&email=john.doe123@gmail.com&password=abcdefghi"
  end
end