class RouteRunsController < ApplicationController
  def show
    route_run = RouteRun.where(id: params[:id], route_id: params[:route_id]).first
    if route_run.nil?
      render_404
    else
      render json: route_run, root: false
    end
  end
end