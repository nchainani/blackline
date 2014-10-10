class ApplicationController < ActionController::API
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

  def required_params(*mandatory_params)
    missing_params = mandatory_params.find_all { |param| params[param].nil? }
    raise MissingAttributesError.new(missing_params) unless missing_params.empty? 
  end

  def rider
    env['BLACKLINE_RIDER']
  end
end
