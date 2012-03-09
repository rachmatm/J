WebClient::Application.routes.draw do
  root :to => 'welcomes#index'
  
  
  resource :dashboards, :only => [:show], :path => 'dashboard'

  #footer
  resource :abouts, :only => [:show], :path => 'about'
  
  resource :status, :only => [:index], :path => 'status'
 

  get 'contact' => 'contacts#index', :as => 'contact'
  get 'goodies' => 'goodies#index', :as => 'goodies'
  get 'api'     => 'apis#index', :as => 'api'
  get 'help'    => 'helps#index', :as => 'help'
  get 'terms'   => 'terms#index', :as=> 'terms'
  get 'privacy' => 'privacys#index', :as=> 'privacy'


  get 'hot_stuff' => 'welcomes#hot_stuff', :as => 'hot_stuff'
  get 'member'    => 'welcomes#member', :as => 'member'
  get 'profile'   => 'welcomes#profile', :as => 'profile'
  get 'profile/other' => 'welcomes#profile_other', :as => 'profile_other'
  
  get 'inbox' => 'welcomes#inbox', :as => 'inbox'
  
 
end