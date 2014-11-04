source "https://rubygems.org"
ruby "2.1.2"

gem "puma", "~> 2.9"

gem "lotusrb", github: "lotus/lotus"
gem "lotus-dynamodb", "~> 0.1"
gem "rake", "~> 10.3"
gem "oj", "~> 2.9"
gem "sidekiq", "~> 3.2"
gem "sidekiq-status", github: "krasnoukhov/sidekiq-status"
gem "retriable", "~> 1.4"

gem "omniauth-spotify", "~> 0.0.1"
gem "omniauth-soundcloud", "~> 1.0"
gem "omniauth-vkontakte", "~> 1.3"
gem "omniauth-lastfm", "~> 0.0.6"

gem "spotify-client", "~> 0.0.1"
gem "soundcloud", "~> 0.3"
gem "vkontakte_api", "~> 1.4"
gem "lastfm", "~> 1.25"

group :development do
  gem "powify", "~> 0.9"
  gem "mina", "~> 0.3"
end

group :test do
  gem "minitest-capybara", "~> 0.7"
  gem "simplecov", "~> 0.8"
  gem "coveralls", "~> 0.7"
end

group :production do
  gem "sentry-raven", "~> 0.9"
end
