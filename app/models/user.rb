class User
  include Lotus::Entity
  self.attributes = :email

  def soundcloud
    AuthRepository.by_user_and_provider(id, "soundcloud")
  end

  def soundcloud?
    !!soundcloud
  end
end
