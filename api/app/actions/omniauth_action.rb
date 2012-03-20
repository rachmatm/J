module OmniauthAction
  class Facebook < ActionWithAppAuth
    before_start :facebook_oauth_dialog

    def facebook_oauth_dialog
      halt 302, {'Location' => FB_OAUTH_URL}
    end
  end

  class AuthenticateFacebook < Action
    before_start :facebook_authentication

    def facebook_authentication
      halt 302, {'Location' => Authentication.current_user_facebook_authentication(params[:code])}
    end
  end

  class AuthenticateTwitter < Action

    def start
      start_with_validates_params [:oauth_token, :oauth_secret, :twitter_id, :username, :realname] do
        render Authentication.current_user_twitter_authentication @parameters
      end
    end
  end

  class Google < ActionWithAppAuth
    before_start :google_oauth_dialog

    def google_oauth_dialog
      halt 302, {'Location' => GOOGLE_OAUTH_URL}
    end
  end

  class AuthenticateGoogle < Action
    before_start :google_authentication
    
    def google_authentication
      halt 302, { 'Location' => Authentication.current_user_google_authentication(params[:code]) }
    end
  end
end
