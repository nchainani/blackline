class RoutesController < ApplicationController
  def index
    routes = Route.find_nearby_routes(params[:lat].to_f, params[:lng].to_f, params.fetch(:radius, 50).to_f)
    render json: routes, root: false
  end
end