get "/",                         to: "home#index",    as: :root
get "/auth/:provider/callback",  to: "auth#callback", as: :auth_callback
get "/auth/failure",             to: "auth#failure",  as: :auth_failure
get "/auth/signout",             to: "auth#signout",  as: :auth_signout

namespace "/provider/:provider" do
  resources :playlists,          only: [:index, :show, :update]
end
