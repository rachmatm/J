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
  
  def notify_forgot_password
    respond_to do |format|

      format.json do
        render :json => api_connect('/authentications/notify_forgot_password.json', params[:forgot_password], "post")
      end

      format.all { respond_not_found }
    end
  end

  def reset_forgot_password
    respond_to do |format|

      format.json do
        render :json => api_connect('/authentications/reset_forgot_password.json', params[:change_password], "post")
      end

      format.all { respond_not_found }
    end
  end

  def facebook
    
    oauth = request.env['omniauth.auth']
    @data = api_connect('/authentications/facebook.json', {:secret_token => oauth.credentials.token}, "post")

    render :layout => 'application_omniaut_callback'
  end

  def twitter
    
    oauth = request.env['omniauth.auth']
    @data = api_connect('/authentications/twitter.json', {:twitter_token => oauth.credentials.token, :twitter_secret => oauth.credentials.secret}, "post")

    render :layout => 'application_omniaut_callback'
  end

  def facebook_connection
    oauth = request.env['omniauth.auth']
    
    @data = api_connect('/me/connections.json',
      {:provider_user_token => oauth.credentials.token, :provider => 'facebook'}, "post")

    flash[:error] = @data['error']
    redirect_to '/#!/setting'
  end
  
  def twitter_connection
    oauth = request.env['omniauth.auth']

    @data = api_connect('/me/connections.json',
      {:provider_user_token => oauth.credentials.token, :provider_user_secret => oauth.credentials.secret, :provider => 'twitter'}, "post")

    flash[:error] = @data['error']
    redirect_to '/#!/setting'
  end

  def failure
    render :layout => 'application_omniaut_failure'
  end
end
