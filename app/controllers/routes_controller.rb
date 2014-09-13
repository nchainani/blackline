class RoutesController < ApplicationController
  respond_to :json

  def index
    {data: "this is it"}
  end
end