require "test_helper"

describe Syncer do
  before do
    @user = User.new(
      email: OmniAuth.config.mock_auth[:spotify][:info][:email],
      username: OmniAuth.config.mock_auth[:spotify][:uid],
    )
    UserRepository.create(@user)

    @spotify = Auth.new(
      user_id: @user.id,
      provider: "spotify",
      external_id: OmniAuth.config.mock_auth[:spotify][:uid].to_s,
      email: OmniAuth.config.mock_auth[:spotify][:info][:email],
      token: OmniAuth.config.mock_auth[:spotify][:credentials][:token],
      secret: OmniAuth.config.mock_auth[:spotify][:credentials][:refresh_token],
    )
    AuthRepository.create(@spotify)
  end

  GoSpotify::Application::PROVIDERS.each do |provider|
    describe provider do
      before do
        @auth = Auth.new(
          user_id: @user.id,
          provider: provider.to_s,
          external_id: OmniAuth.config.mock_auth[provider][:uid].to_s,
          token: OmniAuth.config.mock_auth[provider][:credentials][:token],
        )
        AuthRepository.create(@auth)

        @playlist = Playlist.new(
          user_id: @user.id,
          provider: provider.to_s,
          external_id: @auth.client.remote_playlists.first[:id],
          title: @auth.client.remote_playlists.first[:title],
        )
        PlaylistRepository.create(@playlist)
      end

      it "performs" do
        Syncer.new.perform(@playlist.id)
      end
    end
  end
end
