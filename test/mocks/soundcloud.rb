class SoundcloudClient
  def remote_playlists
    [{ id: 12345, title: "Mixtapes" }]
  end

  def remote_tracks(id)
    [
      ["omg", "omg – wow"]
    ]
  end
end
