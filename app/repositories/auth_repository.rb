class AuthRepository
  include Lotus::Repository

  def self.by_external(provider, external_id)
    query do
      index(:by_external).
      where(provider: provider).
      where(external_id: external_id).
      limit(1)
    end.first
  end
end
