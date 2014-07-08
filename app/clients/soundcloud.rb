require_relative "abstract"

class SoundcloudClient < AbstractClient
  def initialize(*args)
    super

    @api = SoundCloud.new(access_token: @auth.token)
  end

  def playlists
    local = local_playlists

    (default_playlists + remote_playlists).map do |hash|
      find_playlist(local, hash[:id].to_s) do
        playlist = Playlist.new(
          user_id: @auth.user_id,
          provider: @auth.provider
        )

        playlist.external_id = hash[:id].to_s
        playlist.title = hash[:title]

        playlist
      end
    end
  end

  def tracks(playlist)
    remote_tracks(playlist.external_id)
  end

  private
  def default_playlists
    [
      { id: "profile", title: "Tracks" },
      { id: "favorites", title: "Likes" }
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
