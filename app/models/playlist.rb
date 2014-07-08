class Playlist
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :spotify_id,
                    :title, :job_id, :synced_at

  def user
    UserRepository.find(user_id)
  end

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

  def spotify_title
    "[#{provider}] #{title}"
  end
end
