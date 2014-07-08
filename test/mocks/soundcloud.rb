class SoundcloudClient
  def remote_playlists
    [{ id: 12345, title: "Mixtapes" }]
  end

  def remote_tracks(id)
    [Track.new(artist_title: "omg", title: "omg – wow")]
  end
end
