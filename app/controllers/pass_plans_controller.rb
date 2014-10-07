class PassPlansController < ApplicationController
  def show
    render json: PassPlan.find(params[:id]), root: false
  end

  def index
    render json: PassPlan.where(active: true), root: false
  end
end