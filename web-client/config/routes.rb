WebClient::Application.routes.draw do
  root :to => 'welcomes#index'
  
  resource :abouts, :only => [:show], :path => 'about'
  resource :dashboards, :only => [:show], :path => 'dashboard'

  get 'hot-stuff' => 'welcomes#hot_stuff', :as => 'hot_stuff'
  get 'member' => 'welcomes#member', :as => 'member'
  get 'profile' => 'welcomes#profile', :as => 'profile'
  get 'profile/other' => 'welcomes#profile_other', :as => 'profile_other'
end