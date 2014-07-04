class Playlist
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :title, :job_id, :synced_at

  def status
    return unless job_id
    Sidekiq::Status.status(job_id).to_s
  end
end
