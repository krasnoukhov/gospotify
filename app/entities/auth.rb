require "lotus/utils/class"

class Auth
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :email, :token, :secret, :expires_at

  def client
    @client ||= Lotus::Utils::Class.load!("#{provider.capitalize}Client").new(self)
  end
end
