class User
  include Lotus::Entity
  self.attributes = :email, :username

  def auth_for(provider)
    AuthRepository.by_user_and_provider(id, provider.to_s)
  end
end
