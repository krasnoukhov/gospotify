class Syncer
  include Sidekiq::Worker

  def perform(playlist_id)
    playlist = PlaylistRepository.find(playlist_id)

    playlist.job_id = nil
    playlist.synced_at = Time.new
    PlaylistRepository.update(playlist)
  end
end
