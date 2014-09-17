class PassesController < ApplicationController
  def create
    if rider.nil?
      render_422("Rider not found")
    elsif payment_details.nil?
      render_422("Payment details not found")
    else
      new_pass = Pass.create_new_pass!(rider, payment_details, params[:total_tickets])
      new_pass.confirmed!
      render json: new_pass, root: false
    end
  end

  def show
    if pass.nil?
      render_404
    else
      render json: pass, root: false
    end
  end

  private

  def rider
    @rider ||= Rider.where(id: params[:rider_id]).first
  end

  def pass
    @pass ||= Pass.where(id: params[:id], rider: rider).first
  end

  def payment_details
    @payment_details ||= (PaymentDetail.where(id: params[:payment_detail_id], rider: rider).first if params[:payment_detail_id])
  end
end