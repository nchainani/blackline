module Middlewares
  class Authentication
    def initialize( app )
      @app = app
    end

    def call(env)
      if valid_client?(env) || env["PATH_INFO"].to_s.start_with?("/status")
        @app.call(env)
      else
        [ 401, {"Content-Type"=>"application/json"}, [{ error: { httpCode: 401, message: "unknown client" }}.to_json]]
      end
    end

    def valid_client?(env)
      Settings.client_keys.include?(client_token(env))
    end

    def client_token(env)
      request = Rack::Request.new(env)
      (env['HTTP_BLACKLINE_CLIENT_TOKEN'] || request.params['blackline_token']).to_s
    end
  end
end