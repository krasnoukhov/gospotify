APP_ENV = ENV["LOTUS_ENV"] || "development"

require "bundler/setup"
require "tilt/erb"
require "lotus"
require "lotus/action/session"
require "lotus-dynamodb"
require "oj"
require "sidekiq"
require "sidekiq-status"

require "omniauth-spotify"
require "omniauth-soundcloud"
require "omniauth-vkontakte"

require "soundcloud"

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
    configure do
      layout :application
      load_paths << "app"
      routes "config/routes"
    end

    # :nocov:
    configure(:test) { GoSpotify::Application.local_dynamo }
    configure(:development) { GoSpotify::Application.local_dynamo }
    configure(:production) { GoSpotify::Application.remote_dynamo }

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
      )
    end
    # :nocov:
  end
end

APP = GoSpotify::Application.new
LOGGER = Logger.new("log/#{APP_ENV}.log")

require_relative "mapping"
require_relative "sidekiq"
