require "rubygems"
require "bundler"
require 'mime/types'
require 'active_support/secure_random'
require 'erb'
require 'tilt'
require 'async-rack'
require 'pony'
require 'xmlsimple'

module Server
  class Application

    def self.root(path = nil)
      @_root ||= File.expand_path(File.dirname(__FILE__))
      path ? File.join(@_root, path.to_s) : @_root
    end

    def self.env
      @_env ||= ENV['RACK_ENV'] || 'development'
    end

    def self.routes
      @_routes ||= eval(File.read('./config/routes.rb'))
    end
    
    def self.url(path = nil)
      @_url ||= File.join( 'http://localhost:3000/', path.to_s)
    end

    def self.assets(path = nil)
      @_assets ||= 'http://localhost:3000/assets'
      path ? File.join(@_assets, path.to_s) : @_assets
    end

    # Initialize the application
    def self.initialize!
    end
  end
end

Bundler.require(:default, Server::Application.env)

# Load MongoDB
ENV['RACK_ENV'] = Server::Application.env
Mongoid.load!("./config/mongoid.yml")

# I18n Configuration Setup
I18n.load_path += Dir['./config/locale/*.yml']

# Preload application classes
require './app/action'
Dir['./lib/*.rb', './lib/**/*.rb', './app/*.rb', './app/**/*.rb', './app/mailers/*.rb'].each {|f| require f}

# Pusher security credentials ~ http://pusher.com/
Pusher.app_id = '14578'
Pusher.key = 'e510796c20590fbb2f28'
Pusher.secret = 'a0e07edf41d8bd8e01cc'
