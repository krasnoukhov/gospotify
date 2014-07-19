class AbstractClient
  TRACKS_LIMIT = 6_000
  EXCEPTIONS = [VkontakteApi::Error]

  def initialize(auth)
    @auth = auth

    invalidate_token if @auth.expires_at && @auth.expires_at < Time.new
  end

  def local_playlists
    PlaylistRepository.by_user_and_provider(@auth.user_id, @auth.provider)
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

  # :nocov: #
  def cleanup
    raise NotImplementedError
  end
  # :nocov: #

  private
  def find_playlist(playlists, external_id, &block)
    playlist = playlists.find do |x|
      x.provider == @auth.provider && x.external_id == external_id
    end

    playlist ? playlist : yield
  end

  # :nocov: #
  def default_playlists
    raise NotImplementedError
  end

  def remote_playlists
    raise NotImplementedError
  end

  def remote_tracks
    raise NotImplementedError
  end

  def invalidate_token
    raise NotImplementedError
  end
  # :nocov: #
end
