class RidersController < ApplicationController
  acts_as_token_authentication_handler_for Rider, fallback_to_devise: false
  # before_filter :rider till autocomplete is not dependent on Rider

  GOOGLE_API_KEY = "AIzaSyC5jxBcZXb3ym18VEgHN68dT3LcMNgItPM"

  def autocomplete
    url_params = {key: GOOGLE_API_KEY, sensor: false, input: params['input'] }
    url = "https://maps.googleapis.com/maps/api/place/autocomplete/json"

    if params['location']
      url_params[:location] = params['location']
      url_params[:radius] = 500000
    else
      url_params[:components] = params.fetch(:components, "country:us")
    end

    response = HTTParty.get(url, { query: url_params })
    render json: response.body
  end

  def create
    rider = Rider.new(first_name: params[:first_name],
                     last_name: params[:last_name],
                     email: params[:email],
                     password: params[:password])
    if rider.save
      sign_in(rider)
      render json: rider.as_json(auth_token: rider.authentication_token, email: rider.email), status: 201
      return
    else
      warden.custom_failure!
      render json: {error: { httpCode: 422, message: rider.errors }}, status: 422
    end
  end

  def login
    rider = Rider.find_for_database_authentication(email: params[:email])
    if rider.try(:valid_password?, params[:password])
      sign_in(rider)
      render :json=> rider.as_json(auth_token: rider.authentication_token, email: rider.email), status: 200
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
    if rider.update_attributes(password: params[:new_password])
      # Sign in the user by passing validation in case their password changed
      sign_in rider, bypass: true
      render json: rider.as_json(auth_token: rider.authentication_token, email: rider.email), status: 200
    else
      render json: {error: { httpCode: 422, message: rider.errors }}, status: 422
    end
  end
end