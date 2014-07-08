class Track
  include Lotus::Entity
  self.attributes = :artist_title, :title

  def queries
    ["#{artist_title} #{title}", title]
  end
end
