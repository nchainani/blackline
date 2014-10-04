class PaymentDetailsController < ApplicationController
  before_filter :rider

  def create
    required_params(:last4, :card_type, :token)
    customer = Stripe::Customer.create(card: params[:token], description: rider.email)
    payment_detail = rider.payment_details.create!(last4: params[:last4],
                                                   card_type: params[:card_type],
                                                   token: params[:token],
                                                   customer_id: customer.id)
    render json: payment_detail, root: false
  end

  def show
    payment_detail = rider.payment_details.find(params[:id])
    render json: payment_detail, root: false
  end

  def index
    render json: rider.payment_details, root: false
  end

  private

  def rider
    Rider.find(params[:rider_id])
  end
end