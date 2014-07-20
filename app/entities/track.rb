class Track
  include Lotus::Entity
  self.attributes = :artist_title, :title

  def queries
    ["#{better_artist_title} #{better_title}", better_title]
  end

  private
  def better_artist_title
    artist_title.gsub("ft.", "feat.")
  end

  def better_title
    title.gsub("ft.", "feat.")
  end
end
