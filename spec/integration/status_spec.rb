require 'rails_helper'

describe "status endpoint", :type => :request do
  it "returns OK for /status" do
    get '/status'
    response.status.should == 200
  end
end