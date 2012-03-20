class OmniauthController < ApplicationController
  def facebook
    redirect_to BASE_URL + "omniauth/facebook?app_id=#{APP_ID}&secret_key=#{APP_SECRET}"
  end

  def authenticate_facebook
    if params[:facebook_token].present?
      set_token({:key => params[:jotky_token]})
      redirect_to profile_other_path, :notice => "You have successfully logged in with facebook"
    else
      flash[:error] = params[:error]
      redirect_to root_path
    end
  end
  
  def add_facebook_account
    redirect_to BASE_URL + "me/facebook/account?token=#{get_token[:key]}"
  end

  def authenticate_twitter
    oauth_hash = request.env['omniauth.auth']
    parameters = {:oauth_token => oauth_hash.credentials.token,
      :oauth_secret => oauth_hash.credentials.secret,
      :username => oauth_hash.info.nickname,
      :realname => oauth_hash.info.name,
      :twitter_id => oauth_hash.uid
    }

    if token_auth?
      twitter_oauth_response = api_connect('me/twitter/account.json', parameters, "post", false, true)
      set_token({:key => twitter_oauth_response['content']['token']})
      redirect_to profile_other_path, :notice => "You have successfully logged in with twitter"
    else
      twitter_oauth_response = api_connect('omniauth/authenticate_twitter.json', parameters, "post", true, false)
      set_token({:key => twitter_oauth_response['content']['token']})
      redirect_to root_path, :notice => "You have successfully logged in with twitter"
    end

  end

  def google
    redirect_to BASE_URL + "omniauth/google?app_id=#{APP_ID}&secret_key=#{APP_SECRET}"
  end

  def add_google_account
    redirect_to BASE_URL + "me/google/account?token=#{get_token[:key]}"
  end

  def authenticate_google
    if params[:jotky_token].present?
      set_token({:key => params[:jotky_token]})
      redirect_to profile_other_path, :notice => "#{ params[:username] }, you have authenticated your Youtube account"
    else
      flash[:error] = params[:error]
      redirect_to root_path, :error => params[:error]
    end
  end
end
