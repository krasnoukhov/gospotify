class Syncer
  include Sidekiq::Worker

  def perform(playlist_id)
    playlist = PlaylistRepository.find(playlist_id)

    sleep 5

    playlist.job_id = nil
    PlaylistRepository.update(playlist)
  end
end
