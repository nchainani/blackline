class FavoriteLocationsController < ApplicationController
  before_filter :rider

  def create
    required_params(:name)
    create_params = {name: params[:name], description: params[:description], latitude: params[:latitude], longitude: params[:longitude] }
    location = rider.favorite_locations.create!(create_params)
    render json: location, root: false
  end

  def show
    location = rider.favorite_locations.find(params[:id])
    render json: location, root: false
  end

  def index
    arel = rider.favorite_locations
    render json: arel, root: false
  end
end