class RidersController < ApplicationController

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

end