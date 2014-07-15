module GoSpotify::Controllers::Home
  include GoSpotify::Controller

  class Index
    include GoSpotify::CommonAction

    def call(params)
      # :nocov:
      begin
        current_user.auth_for(:spotify).client.me if user_signed_in
      rescue Spotify::AuthenticationError
        redirect_to "/auth/spotify" and return
      end
      # :nocov:
    end
  end
end
