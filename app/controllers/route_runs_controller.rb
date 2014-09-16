class RouteRunsController < ApplicationController
  def show
    if route_run.nil?
      render_404
    else
      render json: route_run, root: false
    end
  end

  def reserve
    if rider.nil?
      render_422("Rider not found")
    elsif (pass.nil? && payment_details.nil?)
      render_422("Payment details not found")
    elsif route_run.nil?
      render_422("Route not found")
    else
      route_run.reserve(rider, (pass || payment_details), location)
    end
  end

  private

  def route_run
    @run ||= RouteRun.where(id: params[:id], route_id: params[:route_id]).first
  end

  def rider
    @rider ||= Rider.where(id: params[:rider_id]).first
  end

  def location
    @location ||= Location.where(id: params[:location_id]).first
  end

  def pass
    @pass ||= (Pass.where(id: params[:pass_id], rider: rider).first if params[:pass_id])
  end

  def payment_details
    @payment_details ||= (PaymentDetail.where(id: params[:payment_detail_id], rider: rider).first if params[:payment_detail_id])
  end
end