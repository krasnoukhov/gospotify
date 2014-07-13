require_relative "abstract"

class SoundcloudClient < AbstractClient
  def initialize(*args)
    super

    @api = SoundCloud.new(access_token: @auth.token)
  end

  private
  def default_playlists
    [
      { id: "profile", title: "Profile tracks" },
      { id: "favorites", title: "Favorited tracks" }
    ]
  end

  # :nocov: #
  def remote_playlists
    @api.get("/me/playlists")
  end

  def remote_tracks(id)
    tracks = if id == "profile"
      @api.get("/me/tracks")
    elsif id == "favorites"
      @api.get("/me/favorites")
    else
      @api.get("/playlists/#{id}")[:tracks]
    end

    tracks.map do |track|
      Track.new(
        artist_title: track[:user][:username],
        title: track[:title],
      )
    end
  end
  # :nocov: #
end
