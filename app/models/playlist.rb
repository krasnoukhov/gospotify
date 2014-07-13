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
    return default_status unless job_id

    default_status.merge(
      Sidekiq::Status::get_all(job_id).map { |k, v| [k.to_s, v] }.to_h
    )
  end

  def spotify_title
    "[#{provider}] #{title}"
  end

  def icon
    case external_id
    when "profile"
      "user"
    when "favorites"
      "star"
    else
      "list"
    end
  end

  private
  def default_status
    {
      "update_time" => nil,
      "status" => nil,
      "total" => nil,
      "at" => nil,
      "message" => nil
    }
  end
end
