class ApplicationController < ActionController::API
  def status
  	render :text => "OK"
  end

  def render_error( http_code, message )
    render :status => http_code, :json => { :error => {:httpCode => http_code, :message => message } }
  end

  def render_404; render_error( 404, 'resource not found' ); end;
  def render_422(message); render_error( 422, message || 'resource not found' ); end;
end
