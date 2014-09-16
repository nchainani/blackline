class TicketsController < ApplicationController
  def create
    if rider.nil?
      render_422("Rider not found")
    elsif (pass.nil? && payment_details.nil?)
      render_422("Payment details not found")
    elsif route_run.nil?
      render_422("Route not found")
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
    if ticket.nil?
      render_404
    else
      render json: ticket, root: false
    end
  end

  private

  def route_run
    @run ||= RouteRun.where(id: params[:route_run_id]).first
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

  def ticket
    @ticket ||= Ticket.where(id: params[:id], rider: rider).first
  end
end