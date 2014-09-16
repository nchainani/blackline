class RouteRunsController < ApplicationController
  def show
    if route_run.nil?
      render_404
    else
      render json: route_run, root: false
    end
  end

  private

  def route_run
    @run ||= RouteRun.where(id: params[:id], route_id: params[:route_id]).first
  end

end