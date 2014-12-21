class TicketsController < ApplicationController
  acts_as_token_authentication_handler_for Rider, fallback_to_devise: false
  before_filter :rider

  def create
    required_params(:amount)

    new_ticket = nil
    if (pass.nil? && payment_details.nil?)
      render_404("Payment details not found")
    elsif route_run.nil?
      render_404("Route not found")
    else
      new_ticket = Ticket.create_new_ticket!(route_run, rider, (pass || payment_details), location, params[:amount])
      new_ticket.confirmed! # This step can ideally be async
      render json: new_ticket, root: false 
    end
  rescue Stripe::StripeError => error
    new_ticket.canceled!
    raise
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
    arel = rider.tickets.where(status: (params[:status] || 'confirmed'))
    if params[:datetime]
      sign = (params[:past] == true ? "<" : ">=")
      arel = arel.joins(:route_run).merge(RouteRun.where("run_datetime #{sign} '#{params[:datetime]}'"))
    end
    render json: arel, root: false
  end

  def smallImage
    ticket = rider.tickets.find(params[:id])
    params = { cht: :qr, chs: '200x200', ch1: ticket.uuid }
    response = HTTParty.get("https://chart.googleapis.com/chart", { query: params })
    send_data response.body
  end

  private

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