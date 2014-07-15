ENV["LOTUS_ENV"] ||= "test"

require "rubygems"
require "bundler/setup"

if ENV["COVERAGE"] == "true"
  require "simplecov"
  require "coveralls"

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]

  SimpleCov.start do
    command_name "test"
    add_filter   "test"
  end
end

require "minitest/autorun"
require "minitest/capybara"
require "minitest/features"
require "sidekiq/testing"

require_relative "../config/applications"
Dir["test/mocks/*.rb"].each { |f| require "./#{f}" }

def before_each
  AuthRepository.clear
  UserRepository.clear
  Sidekiq.redis { |c| c.flushdb }
end

Capybara.app = Rack::Builder.parse_file(File.expand_path("../../config.ru", __FILE__)).first

OmniAuth.config.logger.level = Logger::FATAL
OmniAuth.config.test_mode = true
OmniAuth.config.on_failure = ->(env) {
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
OmniAuth.config.add_mock(:spotify, {
  uid: "john",
  info: {
    email: "john@smith.com",
  },
  credentials: {
    token: "XXX",
    refresh_token: "XXX",
  },
})
GoSpotify::Application::PROVIDERS.each do |provider|
  OmniAuth.config.add_mock(provider, {
    uid: 12345,
    info: {
    },
    credentials: {
      token: "XXX",
    }.merge(provider != :soundcloud ? {
      expires_at: Time.new.to_i + 5*60,
    } : {}),
  })
end
