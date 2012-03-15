WebClient::Application.routes.draw do
  root :to => 'welcomes#index'

  resource :dashboards, :only => [:show], :path => 'dashboard'

  #footer
  resource :abouts, :only => [:show], :path => 'about'

  resource :status, :only => [:index], :path => 'status'

  resource :profile, :only  => [:index], :path => 'profile'

  resource :omniauth, :only => [:google, :authenticate_google, :facebook, :authenticate_facebook] do
    get '/facebook' => 'omniauth#facebook', :as => 'facebook'
    get '/authenticate_facebook' => 'omniauth#authenticate_facebook', :as => 'authenticate_facebook'
    get '/google' => 'omniauth#google', :as => 'google'
    get '/authenticate_google' => 'omniauth#authenticate_google', :as => 'authenticate_google'
  end

  resource :googles, :only => [:upload_video, :upload_video_action] do
    get '/upload_video' => 'googles#upload_video', :as => 'upload_video'
    post '/upload_video' => 'googles#upload_video_action'
  end

  resource :facebooks, :only => [:status, :post_status, :upload_video, :upload_video_create] do
    get '/status' => 'facebooks#status', :as => 'status'
    post '/status' => 'facebooks#post_status'
    get '/upload_photo' => 'facebooks#upload_photo', :as => 'upload_photo'
    post '/upload_photo' => 'facebooks#upload_photo_create'
    get '/upload_video' => 'facebooks#upload_video', :as => 'upload_video'
    post '/upload_video' => 'facebooks#upload_video_create'
  end

  resource :twitter, :only => [:status, :post_status] do
    get '/status' => 'twitter#status', :as => 'status'
    post '/status' => 'twitter#post_status'
  end

  match '/auth/twitter/callback', :to => 'omniauth#authenticate_twitter'

  get 'contact' => 'contacts#index', :as => 'contact'
  get 'goodies' => 'goodies#index', :as => 'goodies'
  get 'api'     => 'apis#index', :as => 'api'
  get 'help'    => 'helps#index', :as => 'help'
  get 'terms'   => 'terms#index', :as=> 'terms'
  get 'privacy' => 'privacys#index', :as=> 'privacy'


  get 'hot_stuff'     => 'welcomes#hot_stuff', :as => 'hot_stuff'
  get 'member'        => 'welcomes#member', :as => 'member'
  
  get 'profile_other' => 'welcomes#profile_other', :as => 'profile_other'
  get 'search_people' =>  'welcomes#search_people', :as => 'search_people'
  get 'jot_detail_active' => 'welcomes#jot_detail_active', :as => 'jot_detail_active'

  get 'nest_manager'  => 'nests#index', :as => 'nest_manager'
  get 'inbox'         => 'welcomes#inbox', :as => 'inbox'

  get 'new-index' => 'welcomes#new_index'


  resource :authentications, :path => 'authentication', :only => [:create]
  resource :registrations, :path => 'registration', :only => [:create]

  resource :tests

  get 'logout' => 'authentications#destroy'
end
