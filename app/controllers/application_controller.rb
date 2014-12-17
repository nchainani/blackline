class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  respond_to :json

  class MissingAttributesError < StandardError
    def initialize(missing_attributes)
      super("Mandatory attributes missing: #{missing_attributes}")
    end
  end

  def status
  	render :text => "OK"
  end

  def render_error( http_code, message )
    render status: http_code, json: { error: { httpCode: http_code, message: message } }
  end

  def render_404(message=nil); render_error( 404, message || 'resource not found' ); end;
  def render_422(message=nil); render_error( 422, message || 'resource not found' ); end;
  def render_410(message=nil); render_error( 410, message || 'resource gone' ); end;
  def render_400(message=nil); render_error( 400, message || 'invalid request' ); end;

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render_404(exception.message)
  end

  rescue_from MissingAttributesError do |exception|
    render_400(exception.message)
  end

  rescue_from Stripe::StripeError do |exception|
    render_400("Payment request failed")
  end

  def required_params(*mandatory_params)
    missing_params = mandatory_params.find_all { |param| params[param].nil? }
    raise MissingAttributesError.new(missing_params) unless missing_params.empty? 
  end

  def rider
    rider = env['BLACKLINE_RIDER']
    unless rider
      authenticate_rider_from_token!
      rider = current_rider
    end
    #raise ActiveRecord::RecordNotFound.new("Rider not found") if rider.nil?
    rider
  end
end
