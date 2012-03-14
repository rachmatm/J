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
  
  class Twitter < ActionWithAppAuth
    before_start :twitter_oauth_dialog

    def twitter_oauth_dialog
      
      oauth_callback_url = "http://127.0.0.1:3000/"

      parameters = { :oauth_consumer_key => TWITTER_CONSUMER_KEY,
        :oauth_callback => CGI.escape( oauth_callback_url ),
        :oauth_nonce => ActiveSupport::SecureRandom.base64(22),
        :oauth_signature_method => "HMAC-SHA1",
        :oauth_timestamp => Time.now.to_i,
        :oauth_version => "1.0"
      }

      oauth_signature = TwitterHelper.oauth_signature("post", "http://127.0.0.1:5000/", parameters)

      parameters.merge!( {:oauth_signature => oauth_signature} )

      header = parameters.sort.collect {|key, value| "#{key}=\"#{value}\"" }.join(', ')

      twitter_oauth_dialog_response = Typhoeus::Request.new("https://api.twitter.com/oauth/request_token",
                                                             :method => :post,
                                                             :headers => { :Authorization => "OAuth #{header}" },
                                                             :params => { :oauth_callback => CGI.escape( oauth_callback_url ) }
                                                            )
      hydra = Typhoeus::Hydra.new
      hydra.queue(twitter_oauth_dialog_response)
      hydra.run

      halt 302, { 'Location' => "http://localhost:3000/" }
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
