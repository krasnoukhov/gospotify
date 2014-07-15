APP_ENV = ENV["LOTUS_ENV"] || "development"

require "bundler/setup"
Bundler.require(:default, APP_ENV)

require "lotus/action/session"
require "tilt/erb"

# :nocov:
if ENV["SENTRY_DSN"]
  require "raven/sidekiq"

  Raven.configure do |config|
    config.current_environment = APP_ENV
  end
end
# :nocov:

module GoSpotify
  module CommonAction
    def self.included(base)
      base.class_eval do
        include Lotus::Action
        include Lotus::Action::Session

        expose :env
        def env
          APP_ENV
        end

        expose :routes
        def routes
          @routes ||= APP.routes
        end

        expose :current_user, :user_signed_in
        def current_user
          @current_user ||= UserRepository.find(session[:user_id]) if session[:user_id]
        end

        def user_signed_in
          @user_signed_in = !!current_user if @user_signed_in.nil?
          @user_signed_in
        end

        private
        def authenticate!
          halt 401 unless user_signed_in
        end
      end
    end

    def call(params)
    end
  end

  class Application < Lotus::Application
    PROVIDERS = [:soundcloud, :vkontakte, :lastfm]

    configure do
      layout :application
      load_paths << "app"
      routes "config/routes"
    end

    # :nocov:
    configure(:test) { GoSpotify::Application.local_dynamo }
    configure(:development) { GoSpotify::Application.local_dynamo }
    configure(:production) do
      Lotus::Controller.configure do
        handle_exceptions false
      end

      GoSpotify::Application.remote_dynamo
    end

    def self.local_dynamo
      AWS.config(
        use_ssl: false,
        dynamo_db_endpoint: "localhost",
        dynamo_db_port: 4567,
        access_key_id: "",
        secret_access_key: "",
      )
    end

    def self.remote_dynamo
      AWS.config(
        access_key_id: ENV["AWS_KEY"],
        secret_access_key: ENV["AWS_SECRET"],
        dynamo_db_endpoint: "dynamodb.eu-west-1.amazonaws.com",
      )
    end
    # :nocov:
  end
end

APP = GoSpotify::Application.new

require_relative "mapping"
require_relative "sidekiq"
