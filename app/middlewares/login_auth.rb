module Middlewares
  class UserNotFound < StandardError
  end

  class LoginAuth
    def initialize( app )
      @app = app
    end

    def call(env)
      if Rails.env.to_sym == :test
        setup_rider_test(env)
      else
        setup_rider(env)
      end
      @app.call(env)
    rescue UserNotFound, ActiveRecord::RecordNotFound => e
      [ 404, {"Content-Type"=>"application/json"}, [{ error: { httpCode: 404, message: "user not found" }}.to_json]]
    end

    private

    def setup_rider(env)
      request = Rack::Request.new env
      if (rider_params = request.params['rider'])
        auth = cached(rider_params) || check_3rd_party(rider_params)
        if auth
          env['BLACKLINE_RIDER'] = auth.rider
          env['BLACKLINE_RIDER_AUTH'] = auth
        else
          raise UserNotFound
        end
      end
    end

    def cached(rider_params)
      arel = Authentication.where(provider: rider_params['provider'], token: rider_params['token'])
      arel = arel.where("expires_at > '#{Time.now}'")
      arel.first
    end

    def check_3rd_party(rider_params)
      auth = case rider_params['provider']
      when "facebook"
        if (rider = authenticate_facebook!(rider_params['token']))
          authenticate!(rider_params.merge(rider))
        end
      when "gplus"
        if (rider = authenticate_gplus!(rider_params['token']))
          authenticate!(rider_params.merge(rider))
        end
      end
    end

    def authenticate_facebook!(token)
      response = HTTParty.get("https://graph.facebook.com/me", { query: { access_token: token }})
      body = JSON.parse(response.body)
      if body["error"]
        raise UserNotFound
      end
      body
    end

    def authenticate_gplus!(token)
      response = HTTParty.get("https://www.googleapis.com/oauth2/v1/tokeninfo", { query: { access_token: token }})
      body = JSON.parse(response.body)
      if body["error"]
        raise UserNotFound
      end
      body.merge('id' => body['user_id'], 'expires_at' => Time.now + body['expires_in'])
    end

    def authenticate!(rider)
      authentication = Authentication.where(provider: rider['provider'], uid: rider['id']).first
      unless authentication
        rider_obj = Rider.find_or_create_by(email: rider['email'])
        rider_obj.first_name = rider['first_name']
        rider_obj.last_name = rider['last_name']
        rider_obj.save!
        authentication = rider_obj.authentications.create!(provider: rider['provider'], uid: rider['id'], token: rider['token'], expires_at: rider['expires_at'])
      else
        authentication.expires_at = rider['expires_at']
        authentication.save!
      end
      authentication
    end

    def setup_rider_test(env)
      request = Rack::Request.new env
      params = request.params
      env['BLACKLINE_RIDER'] = Rider.find(params['rider_id']) if params['rider_id']
      env['BLACKLINE_RIDER_AUTH'] = Authorization.find(params['auth_id']) if params['auth_id']
    end
  end
end