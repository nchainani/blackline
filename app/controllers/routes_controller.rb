class RoutesController < ApplicationController
  def index
    required_params(:lat, :lng)
    routes = Route.find_nearby_routes(params[:lat].to_f, params[:lng].to_f, params.fetch(:radius, 50).to_f)
    render json: routes, root: false
  end

  def show
    route = Route.find(params[:id])
    render json: route, root: false
  end
end