class ApplicationController < ActionController::API
  def status
  	render :text => "OK"
  end
end
