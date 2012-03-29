WebClientV2::Application.routes.draw do
  root :to => "Dashboards#index"

  resource :registrations, :only => [:create]

  resources :authentications, :only => [:create]

  resource :profiles

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
end