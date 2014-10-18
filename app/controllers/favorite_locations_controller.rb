class FavoriteLocationsController < ApplicationController
  before_filter :rider

  def create
    required_params(:name)
    create_params = params.slice(:name, :description, :latitude, :longitude)
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