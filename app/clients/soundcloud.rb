class SoundcloudClient
  def initialize(auth)
    @auth = auth
    @api = SoundCloud.new(access_token: auth.token)
  end

  def playlists
    persisted = local_playlists
    (default_playlists + remote_playlists).map do |hash|
      playlist = persisted.find { |x| x.provider == @auth.provider && x.external_id == hash[:id].to_s } || Playlist.new(user_id: @auth.user_id, provider: @auth.provider)
      playlist.external_id = hash[:id].to_s
      playlist.title = hash[:title]
      playlist
    end
  end

  private
  def default_playlists
    [{ id: "favorites", title: "Favorites" }]
  end

  def local_playlists
    PlaylistRepository.by_user_and_provider(@auth.user_id, @auth.provider)
  end

  # :nocov: #
  def remote_playlists
    @api.get("/me/playlists")
  end
  # :nocov: #
end
