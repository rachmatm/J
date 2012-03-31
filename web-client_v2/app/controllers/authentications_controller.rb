class AuthenticationsController < ApplicationController
  layout 'application_login_with_socmed'

  def create
    respond_to do |format|

      format.json do |format|
        render :json => api_connect('/authentications.json', params[:authentication], "post")
      end

      format.all { respond_not_found }
    end
  end
  
  def facebook
    
    oauth = request.env['omniauth.auth']
    data = api_connect('/authentications/facebook.json', {:secret_token => oauth.credentials.token}, "post")

    cookies[:jotky_token] = data['content']['token']
    redirect_to root_path
  end

  def twitter
    
    oauth = request.env['omniauth.auth']
    data = api_connect('/authentications/twitter.json', {:twitter_token => oauth.credentials.token, :twitter_secret => oauth.credentials.secret}, "post")
    
    cookies[:jotky_token] = data['content']['token']
    redirect_to root_path
  end

  def facebook_connection
    oauth = request.env['omniauth.auth']

    @data = api_connect('/me/connections.json',
      {:connection_token => oauth.credentials.token, :connection_name => 'facebook'}, "post")

    flash[:error] = @data['error']
    redirect_to '/#!/setting'
  end
  
  def twitter_connection
    oauth = request.env['omniauth.auth']

    @data = api_connect('/me/connections.json',
      {:connection_token => oauth.credentials.token, :connection_secret => oauth.credentials.secret, :connection_name => 'twitter'}, "post")

    flash[:error] = @data['error']
    redirect_to '/#!/setting'
  end
end