class Syncer
  include Sidekiq::Worker

  def perform(user_id, provider, playlist_id)
    
  end
end
