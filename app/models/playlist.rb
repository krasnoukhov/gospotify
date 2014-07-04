class Playlist
  include Lotus::Entity
  self.attributes = :user_id, :provider, :external_id, :title
end
