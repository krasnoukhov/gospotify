module GoSpotify::Controllers::Playlists
  include GoSpotify::Controller

  class Index
    include GoSpotify::CommonAction

    def call(params)
      redirect_to routes.path(:root) unless user_signed_in and return
    end
  end
end
