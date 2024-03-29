class PassesController < ApplicationController
  acts_as_token_authentication_handler_for Rider, fallback_to_devise: false
  before_filter :rider

  def create
    required_params(:total_tickets, :amount)

    new_pass = nil
    if payment_details.nil?
      render_404("Payment details not found")
    else
      new_pass = Pass.create_new_pass!(rider, payment_details, pass_plan, {total_tickets: params[:total_tickets], amount: params[:amount]})
      new_pass.confirmed! # This step can ideally be async
      render json: new_pass, root: false
    end
  rescue Stripe::StripeError => error
    new_pass.canceled!
    raise
  end

  def show
    pass = rider.passes.find(params[:id])
    render json: pass, root: false
  end

  def index
    arel = rider.passes.where(status: (params[:status] || 'confirmed')).where("remaining_tickets > 0")
    render json: arel, root: false
  end

  private

  def payment_details
    @payment_details ||= (PaymentDetail.where(id: params[:payment_detail_id], rider: rider).first if params[:payment_detail_id])
  end

  def pass_plan
    @pass_plan ||= PassPlan.where(id: params[:pass_plan_id]).first
  end
end