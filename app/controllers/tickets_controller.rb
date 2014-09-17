class TicketsController < ApplicationController
  before_filter :rider

  def create
    if (pass.nil? && payment_details.nil?)
      render_404("Payment details not found")
    elsif route_run.nil?
      render_404("Route not found")
    else
      new_ticket = Ticket.create_new_ticket!(route_run, rider, (pass || payment_details), location)
      new_ticket.confirmed!
      render json: new_ticket, root: false
    end
  rescue ActiveRecord::RecordInvalid => error
    render_410(error.message)
  rescue RuntimeError => error
    render_422(error.message)
  end

  def show
    ticket = rider.tickets.find(params[:id])
    render json: ticket, root: false
  end

  def index
    render json: rider.tickets, root: false
  end

  private

  def rider
    Rider.find(params[:rider_id])
  end

  def route_run
    @run ||= RouteRun.where(id: params[:route_run_id]).first
  end

  def location
    @location ||= Location.where(id: params[:location_id]).first
  end

  def pass
    @pass ||= (rider.passes.where(id: params[:pass_id]).first if params[:pass_id])
  end

  def payment_details
    @payment_details ||= (rider.payment_details.where(id: params[:payment_detail_id]).first if params[:payment_detail_id])
  end
end