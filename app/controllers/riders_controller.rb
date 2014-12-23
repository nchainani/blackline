class RidersController < ApplicationController
  acts_as_token_authentication_handler_for Rider, fallback_to_devise: false
  # before_filter :rider till autocomplete is not dependent on Rider

  def create
    required_params(:name, :email, :password)
    rider = Rider.new(name: params[:name],
                     email: params[:email],
                     password: params[:password])
    if rider.save
      sign_in(rider)
      render json: rider, root: false, status: 201
      return
    else
      warden.custom_failure!
      render json: {error: { httpCode: 422, message: rider.errors }}, status: 422
    end
  end

  def login
    rider = Rider.find_for_database_authentication(email: params[:rider_email])
    if rider.try(:valid_password?, params[:password]) || (rider && authenticate_rider_from_token!)
      sign_in(rider)
      render json: rider, root: false, status: 200
      return
    else
      render json: {error: { httpCode: 422, message: "Invalid login credentials" }}, status: 422
    end
  end

  def logout
    rider.authentication_token = nil
    rider.save!
    render nothing: true
  end

  def destroy
    rider.destroy
    render nothing: true
  end

  def update_password
    if rider.update_attributes(password: params[:new_password], authentication_token: nil)
      # Sign in the user by passing validation in case their password changed
      sign_in rider, bypass: true
      render json: rider, root: false, status: 200
    else
      render json: {error: { httpCode: 422, message: rider.errors }}, status: 422
    end
  end
end