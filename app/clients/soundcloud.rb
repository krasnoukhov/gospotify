require_relative "abstract"

class SoundcloudClient < AbstractClient
  def initialize(auth)
    @api = SoundCloud.new(access_token: auth.token)

    super
  end

  private
  def default_playlists
    [
      { id: "profile", title: "Profile tracks" },
      { id: "favorites", title: "Favorited tracks" }
    ]
  end

  # :nocov: #
  def remote_playlists
    @api.get("/me/playlists")
  end

  def remote_tracks(id)
    tracks = []
    params = { limit: 200, offset: 0 }
    path = path_for(id)

    while path
      response = @api.get(path, params)
      new_tracks = response.is_a?(Array) ? response : response[:tracks]

      if new_tracks.any?
        tracks.concat(new_tracks)
        params[:offset] = tracks.count + 1
      else
        path = nil
      end
    end

    if id == "profile"
      @api.get("/me/tracks")
    elsif id == "favorites"
      @api.get("/me/favorites")
    else
      @api.get("/playlists/#{id}")[:tracks]
    end

    tracks.map do |track|
      Track.new(
        artist_title: track[:user][:username],
        title: track[:title],
      )
    end
  end

  def path_for(id)
    if id == "profile"
      "/me/tracks"
    elsif id == "favorites"
      "/me/favorites"
    else
      "/playlists/#{id}"
    end
  end
  # :nocov: #
end
