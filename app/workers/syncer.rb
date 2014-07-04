class Syncer
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(playlist_id)
    playlist = PlaylistRepository.find(playlist_id)
    client = playlist.auth.client
    tracks = client.tracks(playlist)

    total(tracks.count)
    tracks.each_with_index do |variants, idx|
      at(idx)
      sleep 1
    end

    playlist.job_id = nil
    playlist.synced_at = Time.new
    PlaylistRepository.update(playlist)
  end
end
