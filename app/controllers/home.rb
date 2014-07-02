module GoSpotify::Controllers::Home
  include GoSpotify::Controller

  class Index
    include GoSpotify::CommonAction

    def call(params)
      redirect_to routes.path(:playlists) if user_signed_in
    end
  end
end
