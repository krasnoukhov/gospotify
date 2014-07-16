class SpotifyClient < AbstractClient
  def initialize(auth)
    @api = Spotify::Client.new(access_token: auth.token, raise_errors: true)

    super
  end

  # :nocov: #
  def me
    @api.me
  end

  def ensure_playlist(playlist)
    # existing = @api.user_playlists(@auth.external_id)["items"].find do |x|
    #   x["name"] == playlist.spotify_title
    # end

    @api.create_user_playlist(
      @auth.external_id,
      playlist.spotify_title,
      false
    )
  end

  def ensure_track(playlist, track)
    track.queries.each do |query|
      search_tracks = @api.search(:track, query)["tracks"]["items"]

      # puts query.inspect
      # puts search_tracks.map { |x| "#{x["artists"].map{ |a| a["name"] }.join(",")} – #{x["name"]}" }.inspect
      # puts "-"*10

      if search_track = search_tracks.first
        Retriable.retriable do
          @api.add_user_tracks_to_playlist(
            @auth.external_id,
            playlist.spotify_id,
            [search_track["uri"]]
          )
        end

        break
      end
    end
  end

  private
  # TODO
  def invalidate_token
  end
  # :nocov: #
end
