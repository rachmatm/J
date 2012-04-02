WebClientV2::Application.routes.draw do
  root :to => "Dashboards#index"

  resource :registrations, :only => [:create]

  resources :authentications, :only => [:create]

  resource :profiles, :only => [:show, :update]

  resources :jots do
    get 'favorite'
    get 'thumbsup'
    get 'thumbsdown'

    resources :comments, :only => [:create, :index]
  end

  get '/auth/facebook', :as => 'login_with_facebook'
  get '/auth/facebook/callback' => 'authentications#facebook'
  get '/auth/twitter', :as => 'login_with_twitter'
  get '/auth/twitter/callback' => 'authentications#twitter'
  get '/auth/failure' => 'authentications#failure'
  get '/auth/facebook_connection', :as => 'facebook_connection'
  get '/auth/facebook_connection/callback' => 'authentications#facebook_connection'
  get '/auth/twitter_connection', :as => 'twitter_connection'
  get '/auth/twitter_connection/callback' => 'authentications#twitter_connection'

  resource :connections, :only => [] do
    get 'remove/:id' => 'connections#remove', :as => 'remove'
  end
end