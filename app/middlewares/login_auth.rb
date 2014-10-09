module Middlewares
  class LoginAuth
    def initialize( app )
      @app = app
    end

    def call(env)
      request = Rack::Request.new env
      if (rider_params = request.params['rider'])
        auth = setup_rider(rider_params)
        if auth
          env['RIDER_ID'] = auth.rider_id
        end
      end
      @app.call(env)
    end

    private

    def setup_rider(rider_params)
      auth = case rider_params['provider']
      when "facebook"
        if (rider = authenticate_facebook(rider_params['token']))
          authenticate!(rider_params.merge(rider))
        end
      end
    end

    def authenticate_facebook(token)
      response = HTTParty.get("https://graph.facebook.com/me", { query: { access_token: token }})
      body = JSON.parse(response.body)
      body
    end

    def authenticate!(rider)
      authentication = Authentication.where(provider: rider['provider'], uid: rider['id']).first
      unless authentication
        rider_obj = Rider.find_or_create_by(email: rider['email'])
        rider_obj.first_name = rider['first_name']
        rider_obj.last_name = rider['last_name']
        rider_obj.save!
        authentication = rider_obj.authentications.create!(provider: rider['provider'], uid: rider['id'], token: rider['token'])
      end
      authentication
    end

  end
end