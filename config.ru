require_relative "application"

use Rack::Session::Cookie, secret: ENV["SECRET"]
use RackSessionAccess::Middleware if ENV["RACK_ENV"] == "test"
use OmniAuth::Builder do
  provider :spotify, ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"], {
    scope: "playlist-modify playlist-modify-private playlist-read-private user-read-email"
  }
  provider :soundcloud, ENV["SOUNDCLOUD_KEY"], ENV["SOUNDCLOUD_SECRET"]
end

run APP
