class PaymentDetailsController < ApplicationController
  before_filter :rider

  def create
    required_params(:number, :token)
    payment_detail = rider.payment_details.create!(number: number, token: token)
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