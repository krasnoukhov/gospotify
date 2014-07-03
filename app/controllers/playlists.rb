module GoSpotify::Controllers::Playlists
  include GoSpotify::Controller

  class Show
    include GoSpotify::CommonAction

    before :authenticate!
    before { |params| @auth = current_user.auth_for(params[:id]) }
    before { halt 401 unless @auth }

    def call(params)
      self.body = JSON.dump(["omg"])
    end
  end
end
