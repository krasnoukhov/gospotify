module GoSpotify::Controllers::Auth
  include GoSpotify::Controller

  class Callback
    include GoSpotify::CommonAction

    def call(params)
      omniauth = params.env["omniauth.auth"]
      auth = compute_auth(omniauth)

      # Do not allow users w/o email
      if !auth.email && !(auth.user_id || user_signed_in)
        redirect_to routes.path(:auth_failure, message: "email_required") and return
      end

      # Fuck coolhackers
      if user_signed_in && auth.user_id && current_user.id != auth.user_id
        redirect_to routes.path(:auth_failure, message: "auth_taken") and return
      end

      user_id = compute_user_id(auth)
      auth.user_id ||= user_id
      AuthRepository.persist(auth)

      session[:user_id] = user_id
      redirect_to routes.path(:root)
    end

    def compute_auth(omniauth)
      auth = AuthRepository.by_external(
        omniauth[:provider], omniauth[:uid].to_s
      ) || Auth.new(
        provider: omniauth[:provider],
        external_id: omniauth[:uid].to_s
      )

      auth.email = omniauth[:info][:email]
      auth.token = omniauth[:credentials][:token]
      if omniauth[:credentials][:refresh_token]
        auth.secret = omniauth[:credentials][:refresh_token]
      end

      auth
    end

    def compute_user_id(auth)
      case
      when auth.user_id
        auth.user_id
      when user_signed_in
        current_user.id
      else
        user = User.new(email: auth.email)
        UserRepository.create(user)
        user.id
      end
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
