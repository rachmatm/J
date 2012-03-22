require './application'
Server::Application.initialize!

# Development middlewares
if Server::Application.env == 'development'
  use AsyncRack::CommonLogger

  # Enable code reloading on every request
  use Rack::Reloader, 0

  # Debugger
  require 'ruby-debug'  
end

# Rack Up
use Rack::Session::Cookie, :key => 'api_jotky', :path => '/lord', :domain => 'localhost', :expire_after => 2592000, :secret => 'my_secret'

run Server::Application.routes

# Running thin :
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -R config.ru start
#
# Vebose mode :
#
#   Very useful when you want to view all the data being sent/received by thin
#
#   bundle exec thin --max-persistent-conns 1024 --timeout 0 -V -R config.ru start
#
