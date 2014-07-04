class SoundcloudClient
  def initialize(auth)
    @auth = auth
    @api = SoundCloud.new(access_token: auth.token)
  end

  def playlists
    (default_playlists + remote_playlists).map do |hash|
      playlist = Playlist.new(user_id: @auth.user_id, provider: @auth.provider)
      playlist.external_id = hash[:id]
      playlist.title = hash[:title]
      playlist
    end
  end

  private
  def default_playlists
    [{ id: "favorites", title: "Favorites" }]
  end

  # :nocov: #
  def remote_playlists
    @api.get("/me/playlists")
  end
  # :nocov: #
end
