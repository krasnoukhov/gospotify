class Syncer
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(playlist_id)
    playlist = PlaylistRepository.find(playlist_id)
    client = playlist.auth.client
    spotify = playlist.user.auth_for(:spotify).client
    tracks = client.tracks(playlist)

    spotify_playlist = spotify.ensure_playlist(playlist)
    playlist.spotify_id = spotify_playlist["id"]
    PlaylistRepository.update(playlist)

    total(tracks.count)
    tracks.each_with_index do |track, idx|
      at(idx)
      spotify.ensure_track(playlist, track)
    end

    playlist.job_id = nil
    playlist.synced_at = Time.new
    PlaylistRepository.update(playlist)
  end
end
