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
      self.body = Oj.dump(@auth.client.playlists.map { |p| PlaylistPresenter.new(p).to_h })
    end
  end

  class Show
    include GoSpotify::CommonAction
    include CommonAction

    def call(params)
      playlist = @auth.client.playlists.find { |x| x.external_id == params[:id] }
      halt 401 unless playlist

      self.format = :json
      self.body = Oj.dump(PlaylistPresenter.new(playlist).to_h)
    end
  end

  class Update
    include GoSpotify::CommonAction
    include CommonAction

    def call(params)
      playlist = @auth.client.playlists.find { |x| x.external_id == params[:id] }
      halt 401 unless playlist

      PlaylistRepository.persist(playlist)
      playlist.job_id = Syncer.perform_async(playlist.id)
      PlaylistRepository.persist(playlist)

      self.format = :json
      self.body = Oj.dump(PlaylistPresenter.new(playlist).to_h)
    end
  end
end
