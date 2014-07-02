class AuthRepository
  include Lotus::Repository

  def self.by_user_and_provider(user_id, provider)
    query do
      where(user_id: user_id).
      where(provider: provider).
      limit(1)
    end.first
  end

  def self.by_external(provider, external_id)
    query do
      index(:by_external).
      where(provider: provider).
      where(external_id: external_id).
      limit(1)
    end.first
  end
end
