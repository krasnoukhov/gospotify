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
    [{ id: "favorites", title: "Favorites" }]
  end

  # :nocov: #
  def remote_playlists
    @api.get("/me/playlists")
  end

  def remote_tracks(id)
    tracks = if id == "favorites"
      @api.get("/me/favorites")
    else
      @api.get("/playlists/#{id}")[:tracks]
    end

    tracks.map do |track|
      # ¯\_(ツ)_/¯
      # artist, title = if track[:title].scan("-").count == 1
      #   track.split("-")
      # else
      #   [track[:user][:username], track[:title]]
      # end

      [track[:title], "#{track[:user][:username]} #{track[:title]}"]
    end
  end
  # :nocov: #
end
