require "test_helper"

describe Syncer do
  before do
    user = User.new(
      email: OmniAuth.config.mock_auth[:spotify][:info][:email],
      username: OmniAuth.config.mock_auth[:spotify][:uid],
    )
    UserRepository.create(user)

    spotify_auth = Auth.new(
      user_id: user.id,
      provider: "spotify",
      external_id: OmniAuth.config.mock_auth[:spotify][:uid].to_s,
      email: OmniAuth.config.mock_auth[:spotify][:info][:email],
      token: OmniAuth.config.mock_auth[:spotify][:credentials][:token],
      secret: OmniAuth.config.mock_auth[:spotify][:credentials][:refresh_token],
    )
    AuthRepository.create(spotify_auth)

    soundcloud_auth = Auth.new(
      user_id: user.id,
      provider: "soundcloud",
      external_id: OmniAuth.config.mock_auth[:soundcloud][:uid].to_s,
      token: OmniAuth.config.mock_auth[:soundcloud][:credentials][:token],
    )
    AuthRepository.create(soundcloud_auth)

    @playlist = Playlist.new(
      user_id: user.id,
      provider: "soundcloud",
      external_id: SoundcloudClient.new(soundcloud_auth).remote_playlists.first[:id],
      title: SoundcloudClient.new(soundcloud_auth).remote_playlists.first[:title],
    )
    PlaylistRepository.create(@playlist)
  end

  it "performs" do
    Syncer.new.perform(@playlist.id)
  end
end
