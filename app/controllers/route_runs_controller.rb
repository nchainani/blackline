class RouteRunsController < ApplicationController
  def show
    if route_run.nil?
      render_404
    else
      render json: route_run, root: false
    end
  end

  def start
    route_run.start!
    render nothing: true
  end

  def update_location
    required_params(:lat, :lng)
    route_run.update_location!(params[:lat], params[:lng])
    render nothing: true
  end

  def complete
    route_run.complete!
    render nothing: true
  end

  private

  def route_run
    @run ||= RouteRun.where(id: params[:id], route_id: params[:route_id]).first
  end

end