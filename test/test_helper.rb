ENV["RACK_ENV"] ||= "test"

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
require "rack_session_access"
require "rack_session_access/capybara"
require "capybara/webkit"

require "tilt/erb"
require_relative "../application"

def before_each
  AuthRepository.clear
  UserRepository.clear
end

Capybara.app = Rack::Builder.parse_file(File.expand_path("../../config.ru", __FILE__)).first
Capybara.default_wait_time = 10
Capybara.javascript_driver = :webkit

OmniAuth.config.logger.level = Logger::FATAL
OmniAuth.config.test_mode = true
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
OmniAuth.config.add_mock(:soundcloud, {
  uid: 12345,
  info: {
  },
  credentials: {
    token: "XXX",
  },
})
