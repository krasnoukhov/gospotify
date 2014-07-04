module GoSpotify::Controllers::Playlists
  include GoSpotify::Controller

  module CommonAction
    def self.included(base)
      base.class_eval do
        before :authenticate!
        before { |params| @auth = current_user.auth_for(params[:provider]) }
        before { halt 401 unless @auth }
      end
    end
  end

  class Index
    include GoSpotify::CommonAction
    include CommonAction

    def call(params)
      self.format = :json
      self.body = Oj.dump(@auth.client.playlists)
    end
  end

  class Update
    include GoSpotify::CommonAction
    include CommonAction

    expose :playlists
    def call(params)
      Syncer.perform_async(current_user.id, params[:provider], params[:id])

      self.format = :json
      self.body = Oj.dump("status" => "ok")
    end
  end
end
