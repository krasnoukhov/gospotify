require_relative "config/applications"

use Raven::Rack if ENV["SENTRY_DSN"]
use Rack::Session::Cookie, secret: ENV["SECRET"]
use OmniAuth::Builder do
  provider :spotify, ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"], {
    scope: "playlist-modify playlist-modify-private playlist-read-private user-read-email user-follow-read"
  }
  provider :soundcloud, ENV["SOUNDCLOUD_KEY"], ENV["SOUNDCLOUD_SECRET"]
  provider :vkontakte, ENV["VK_KEY"], ENV["VK_SECRET"], {
    scope: "audio offline"
  }
  provider :lastfm, ENV["LASTFM_KEY"], ENV["LASTFM_SECRET"]
end

run APP
