class PlaylistRepository
  include Lotus::Repository

  def self.by_user_and_provider(user_id, provider)
    query do
      index(:by_user).
      where(user_id: user_id).
      where(provider: provider)
    end.all
  end
end
