# Load the Rails application.
require File.expand_path('../application', __FILE__)
require "#{Rails.root}/app/middlewares/token_authentication"
require "#{Rails.root}/app/middlewares/login_auth"

Rails.application.configure do
  config.middleware.use(Middlewares::TokenAuthentication)
  config.middleware.use(Middlewares::LoginAuth)
end

# Initialize the Rails application.
Rails.application.initialize!
