get "/",                         to: "home#index", as: :root
get "/auth/:provider/callback",  to: "session#callback"
get "/auth/failure",             to: "session#failure"
get "/auth/signout",             to: "session#signout"
