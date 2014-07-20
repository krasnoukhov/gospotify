require_relative "abstract"

class SpotifyClient < AbstractClient
  def initialize(auth)
    @api = Spotify::Client.new(
      access_token: auth.token,
      raise_errors: true,
      persistent: true,
    )

    super
  end

  # :nocov: #
  def me
    @api.me
  end

  def ensure_playlist(playlist)
    spotify_playlist = @api.user_playlists(@auth.external_id)["items"].find do |x|
      x["id"] == playlist.spotify_id || x["name"] == playlist.spotify_title
    end

    if spotify_playlist
      spotify_playlist["track_uris"] = @api.user_playlist_tracks(
        @auth.external_id,
        spotify_playlist["id"]
      )["items"].map { |x| x["track"]["uri"] }
    else
      spotify_playlist = @api.create_user_playlist(
        @auth.external_id,
        playlist.spotify_title,
        false
      )
      spotify_playlist["track_uris"] = []
    end

    spotify_playlist
  end

  def ensure_track(spotify_playlist, track)
    track.queries.each do |query|
      search_tracks = @api.search(:track, query)["tracks"]["items"]

      # puts query.inspect
      # puts search_tracks.map { |x| "#{x["artists"].map{ |a| a["name"] }.join(",")} – #{x["name"]}" }.inspect
      # puts "-"*10

      if search_track = search_tracks.first
        if spotify_playlist["track_uris"].find { |x| x == search_track["uri"] }
          break
        end

        Retriable.retriable do
          @api.add_user_tracks_to_playlist(
            @auth.external_id,
            spotify_playlist["id"],
            [search_track["uri"]]
          )
        end

        spotify_playlist["track_uris"] << search_track["uri"]
        spotify_playlist["track_uris"].uniq!

        break
      end
    end
  end

  def cleanup
    @api.close_connection
  end

  private
  # TODO
  def invalidate_token
  end
  # :nocov: #
end
