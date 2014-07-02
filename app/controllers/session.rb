module GoSpotify::Controllers::Session
  include GoSpotify::Controller

  class Callback
    include GoSpotify::CommonAction

    def call(params)
      auth = params.env["omniauth.auth"]
      LOGGER.info params.env
      session[:user_id] = "lol"

      redirect_to routes.path(:root)
    end
  end

  class Failure
    include GoSpotify::CommonAction

    expose :message

    def call(params)
      @message = params[:message]
    end
  end

  class Signout
    include GoSpotify::CommonAction

    def call(params)
      session[:user_id] = nil

      redirect_to routes.path(:root)
    end
  end
end
