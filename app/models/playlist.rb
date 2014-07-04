class Playlist
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :title, :job_id, :synced_at

  def auth
    AuthRepository.by_user_and_provider(user_id, provider)
  end

  def status
    return {
      "update_time" => nil,
      "status" => nil,
      "total" => nil,
      "at" => nil,
      "message" => nil
    } unless job_id

    Sidekiq::Status::get_all(job_id).map { |k, v| [k.to_s, v] }.to_h
  end
end
