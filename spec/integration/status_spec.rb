require 'rails_helper'

describe "status endpoint", :type => :request do
  it "returns OK for /status" do
    get '/status'
    response.code.should == "200"
  end
end