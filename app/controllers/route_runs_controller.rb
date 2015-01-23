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
    unless route_run.complete?
      location_update = route_run.route_run_location_updates.find_or_create_by!(route_run_id: route_run.id)
      location_update.update_attributes!(lat: params[:lat], lng: params[:lng])
    end
    render nothing: true
  end

  def complete
    route_run.complete!
    render nothing: true
  end

  def location_status
    location = route_run.route_run_location_updates.last
    status = { status: route_run.workflow_state, lat: location.try(:lat), lng: location.try(:lng) }
    render json: status
  end

  def tickets
    render json: route_run.tickets.where("status <> 'canceled'").joins(:rider).order("riders.name"), no_route_run: true, root: false
  end

  private

  def route_run
    @run ||= RouteRun.where(id: params[:id], route_id: params[:route_id]).first
  end

end