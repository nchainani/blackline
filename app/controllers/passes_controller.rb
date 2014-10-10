class PassesController < ApplicationController
  before_filter :rider

  def create
    required_params(:total_tickets, :amount)

    if payment_details.nil?
      render_404("Payment details not found")
    else
      new_pass = Pass.create_new_pass!(rider, payment_details, pass_plan, params[:total_tickets], params[:amount])
      new_pass.confirmed!
      render json: new_pass, root: false
    end
  end

  def show
    pass = rider.passes.find(params[:id])
    render json: pass, root: false
  end

  def index
    render json: rider.passes, root: false
  end

  private

  def payment_details
    @payment_details ||= (PaymentDetail.where(id: params[:payment_detail_id], rider: rider).first if params[:payment_detail_id])
  end

  def pass_plan
    @pass_plan ||= PassPlan.where(id: params[:pass_plan_id]).first
  end
end