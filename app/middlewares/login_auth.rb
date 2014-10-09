module Middlewares
  class LoginAuth
    def initialize( app )
      @app = app
    end

    def call(env)
      request = Rack::Request.new env
      if (rider = request.params['rider'])
        auth = setup_rider(rider)
        if auth
          env['RIDER_ID'] = auth.rider_id
        end
      end
      @app.call(env)
    end

    private

    def setup_rider(rider)
      auth = case rider['provider']
      when "facebook"
        if authenticate_facebook(rider['uid'], rider['token'])
          authenticate!(rider)
        end
      end
    end

    def authenticate_facebook(uid, token)
      response = HTTParty.get("https://graph.facebook.com/me", { query: {fields: :id, access_token: token }})
      body = JSON.parse(response.body)
      body['id'] == uid
    end

    def authenticate!(rider)
      authentication = Authentication.where(provider: rider['provider'], uid: rider['uid']).first
      unless authentication
        rider_obj = Rider.find_or_create_by(email: rider['email'])
        rider_obj.first_name = rider['first_name']
        rider_obj.last_name = rider['last_name']
        rider_obj.save!
        authentication = rider_obj.authentications.create!(provider: rider['provider'], uid: rider['uid'], token: rider['token'])
      end
      authentication
    end

  end
end