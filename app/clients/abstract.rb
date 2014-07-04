class AbstractClient
  def initialize(auth)
    @auth = auth
  end

  private
  def local_playlists
    PlaylistRepository.by_user_and_provider(@auth.user_id, @auth.provider)
  end

  def find_playlist(playlists, external_id, &block)
    playlist = playlists.find do |x|
      x.provider == @auth.provider && x.external_id == external_id
    end

    playlist ? playlist : yield
  end
end
