class Playlist
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :title, :job_id

  def serializable_hash
    (self.class.attributes + [:status]).map { |x| [x.to_s, public_send(x) ]}.to_h
  end

  def status
    return unless job_id
    Sidekiq::Status::status(job_id).to_s
  end
end
