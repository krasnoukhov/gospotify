require_relative "application"

use Rack::Session::Cookie, secret: ENV["SECRET"]
use OmniAuth::Builder do
  provider :spotify, ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"], {
    scope: "playlist-modify playlist-modify-private playlist-read-private user-read-email"
  }
end

run APP
