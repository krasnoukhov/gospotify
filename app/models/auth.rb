class Auth
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :email, :token, :secret
end
