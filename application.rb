require "lotus"
require "lotus/action/session"
require "lotus-dynamodb"

require "omniauth-spotify"
require "omniauth-soundcloud"
require "omniauth-vkontakte"

AWS.config(
  access_key_id: ENV["AWS_KEY"],
  secret_access_key: ENV["AWS_SECRET"],
)

module GoSpotify
  module CommonAction
    def self.included(base)
      base.class_eval do
        include Lotus::Action
        include Lotus::Action::Session

        expose :routes
        def routes
          @routes ||= APP.routes
        end

        expose :current_user, :user_signed_in
        def current_user
          @current_user ||= "lol" if session[:user_id]
        end

        def user_signed_in
          @user_signed_in = !!current_user if @user_signed_in.nil?
          @user_signed_in
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
      routes  "config/routes"
      mapping "config/mapping"
    end
  end
end

APP = GoSpotify::Application.new
LOGGER = Logger.new("log/development.log")
