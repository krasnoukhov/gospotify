require_relative "abstract"

class LastfmClient < AbstractClient
  def initialize(auth)
    @api = Lastfm.new(ENV["LASTFM_KEY"], ENV["LASTFM_SECRET"])
    @api.session = auth.token

    super
  end

  private
  def default_playlists
    [
      { id: "favorites", title: "Loved tracks" }
    ]
  end

  # :nocov: #
  def remote_playlists
    []
  end

  def remote_tracks(id)
    tracks = if id == "favorites"
      @api.user.get_loved_tracks(user: @auth.external_id, limit: TRACKS_LIMIT)
    else
      []
    end

    tracks.map do |track|
      Track.new(
        artist_title: track["artist"]["name"],
        title: track["name"],
      )
    end
  end
  # :nocov: #
end
