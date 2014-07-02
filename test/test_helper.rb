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
require "tilt/erb"
require_relative "../application"

Capybara.app = Rack::Builder.parse_file(File.expand_path("../../config.ru", __FILE__)).first
Capybara.javascript_driver = :webkit

OmniAuth.config.logger.level = Logger::FATAL
OmniAuth.config.test_mode = true
OmniAuth.config.add_mock(:spotify, {
  uid: "12345",
  info: {
    name: "John Smith",
    email: "john@smith.com",
  }
})

AWS.config(
  use_ssl: false,
  dynamo_db_endpoint: "localhost",
  dynamo_db_port: 4567,
  access_key_id: "",
  secret_access_key: "",
)
Net::HTTP.new("localhost", AWS.config.dynamo_db_port).delete("/")
