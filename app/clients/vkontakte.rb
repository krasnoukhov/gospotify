require_relative "abstract"

class VkontakteClient < AbstractClient
  def initialize(*args)
    super

    @api = VkontakteApi::Client.new(@auth.token)
  end

  private
  def default_playlists
    [
      { id: "profile", title: "Tracks" },
    ]
  end

  # :nocov: #
  def remote_playlists
    @api.audio.get_albums[1..-1].map do |x|
      { id: x[:album_id].to_s, title: x[:title] }
    end
  end

  def remote_tracks(id)
    tracks = if id == "profile"
      @api.audio.get
    else
      @api.audio.get(album_id: id)
    end

    tracks.map do |track|
      Track.new(
        artist_title: track[:artist],
        title: track[:title],
      )
    end
  end
  # :nocov: #
end
