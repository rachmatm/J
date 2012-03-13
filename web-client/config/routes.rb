WebClient::Application.routes.draw do
  root :to => 'welcomes#index'
  
  
  resource :dashboards, :only => [:show], :path => 'dashboard'

  #footer
  resource :abouts, :only => [:show], :path => 'about'
  
  resource :status, :only => [:index], :path => 'status'
 
  resource :omniauth, :only => [:google, :authenticate_google] do
    get '/google' => 'omniauth#google', :as => 'google'
    get '/authenticate_google' => 'omniauth#authenticate_google', :as => 'authenticate_google'
  end

  resource :googles, :only => [:upload_video, :upload_video_action] do
    get '/upload_video' => 'googles#upload_video', :as => 'upload_video'
    post '/upload_video' => 'googles#upload_video_action'
  end

  get 'contact' => 'contacts#index', :as => 'contact'
  get 'goodies' => 'goodies#index', :as => 'goodies'
  get 'api'     => 'apis#index', :as => 'api'
  get 'help'    => 'helps#index', :as => 'help'
  get 'terms'   => 'terms#index', :as=> 'terms'
  get 'privacy' => 'privacys#index', :as=> 'privacy'


  get 'hot_stuff' => 'welcomes#hot_stuff', :as => 'hot_stuff'
  get 'member'    => 'welcomes#member', :as => 'member'
  get 'profile'   => 'welcomes#profile', :as => 'profile'
  get 'profile_other' => 'welcomes#profile_other', :as => 'profile_other'

  
  
  get 'inbox' => 'welcomes#inbox', :as => 'inbox'

  get 'new-index' => 'welcomes#new_index'


  resource :authentications, :path => 'authentication', :only => [:create]
  resource :registrations, :path => 'registration', :only => [:create]
end
