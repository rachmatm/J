WebClient::Application.routes.draw do
  root :to => 'searches#index'

  resource :dashboards, :only => [:show], :path => 'dashboard'

  #footer
  
 # get 'about' => 'abouts#show', :as => 'about'

  resource :status, :only => [:index], :path => 'status'

  resource :omniauth, :only => [:google, :authenticate_google, :facebook, :authenticate_facebook] do
    get '/facebook' => 'omniauth#facebook', :as => 'login_facebook'
    get '/authenticate_facebook' => 'omniauth#authenticate_facebook', :as => 'authenticate_facebook'
    get '/add_facebook' => 'omniauth#add_facebook_account', :as => 'add_facebook'
    get '/google' => 'omniauth#google', :as => 'login_google'
    get '/add_google' => 'omniauth#add_google_account', :as => 'add_google'
    get '/authenticate_google' => 'omniauth#authenticate_google', :as => 'authenticate_google'
  end

  resource :googles, :only => [:upload_video, :upload_video_action] do
    get '/upload_video' => 'googles#upload_video', :as => 'upload_video'
    post '/upload_video' => 'googles#upload_video_action'
  end

  resource :facebooks, :only => [:status, :post_status, :upload_video, :upload_video_create] do
    get '/wall' => 'facebooks#wall', :as => 'wall'
    get '/status' => 'facebooks#status', :as => 'status'
    post '/status' => 'facebooks#post_status'
    get '/upload_photo' => 'facebooks#upload_photo', :as => 'upload_photo'
    post '/upload_photo' => 'facebooks#upload_photo_create'
    get '/upload_video' => 'facebooks#upload_video', :as => 'upload_video'
    post '/upload_video' => 'facebooks#upload_video_create'
  end

  resource :twitter, :only => [:status, :post_status] do
    get '/timeline' => 'twitter#timeline', :as => 'timeline'
    get '/status' => 'twitter#status', :as => 'status'
    post '/status' => 'twitter#post_status'
  end

  resources :jots do
    get 'thumbsup'
    get 'thumbsdown'
    get 'destroy'
    post 'comments' => 'jots#create_comments'
    get 'fav'
    get 'rejot'

    resources :jot_comments, :path => 'comments'
  end

  resource :profiles
  
  resource :account_settings, :except => [:update, :new, :create, :destroy, :edit, :show] do
    post '/update_email' => 'account_settings#update_email', :as => 'update_email'
    post '/update_password' => 'account_settings#update_password', :as => 'update_password'
    post '/update_privacy' => 'account_settings#update_privacy', :as => 'update_privacy'
    post '/update_your_stream' => 'account_settings#update_your_stream', :as => 'update_your_stream'
    post '/update_default_post' => 'account_settings#update_default_post', :as => 'update_default_post'
    post '/update_connection' => 'account_settings#update_connection', :as => 'update_connection'
    post '/update_media_upload' => 'account_settings#update_media_upload', :as => 'update_media_upload'
  end


  match '/auth/twitter/callback', :to => 'omniauth#authenticate_twitter'

  get 'contact' => 'contacts#index', :as => 'contact'
  get 'goodies' => 'goodies#index', :as => 'goodies'
  get 'api'     => 'apis#index', :as => 'api'
  get 'help'    => 'helps#index', :as => 'help'
  get 'terms'   => 'terms#index', :as=> 'terms'
  get 'privacy' => 'privacys#index', :as=> 'privacy'


  
  get 'member'        => 'welcomes#member', :as => 'member'
  
  get 'profile_other' => 'welcomes#profile_other', :as => 'profile_other'
  get 'search_people' =>  'welcomes#search_people', :as => 'search_people'
  get 'jot_detail_active' => 'welcomes#jot_detail_active', :as => 'jot_detail_active'

  get 'nest_manager'  => 'nests#index', :as => 'nest_manager'
  get 'inbox'         => 'welcomes#inbox', :as => 'inbox'

  get 'new-index' => 'welcomes#new_index'

  get '/forgot_password' => 'authentications#forgot_password', :as => 'forgot'
  post '/forgot_password' => 'authentications#notify_forgot_password'

  resources :authentications

  # registration
  get 'signup' => 'registrations#new', :as => :signup
  get 'logout' => 'authentications#logout', :as => :logout
  post 'signup' => 'registrations#create', :as => :signup_create

  resource :tests

  resources :maps

  resources :notification, :path => 'notification', :only => [:index, :destroy] do
    get 'destroy'
  end

  resources :files
  get 'about' => 'abouts#show'
  
  get 'home_detail' => 'homes#show'
  get 'hot_stuff'     => 'hotstuffs#show'
  get 'jotpost' => 'jotposts#show'

  resources :searches, :path => 'search'
end
