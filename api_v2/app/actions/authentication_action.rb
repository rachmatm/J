module AuthenticationAction

  class Create < ActionWithAppAuth

    def start
      render Authentication.set(params[:username], params[:password])
      finish
    end
  end
  
  class NotifyForgotPassword < ActionWithAppAuth
    def start
      render Authentication.notify_forgot_password params[:email], @client.reset_password_confirmation_url
      finish
    end
  end

  class ResetForgotPassword < ActionWithAppAuth
    def start
      render Authentication.reset_forgot_password params[:password], params[:reset_forgot_password_token]
      finish
    end
  end

  module Facebook
    class Create < ActionWithAppAuth

      def start
        render Authentication.set_by_facebook(params[:secret_token])
        finish
      end
    end
  end

  module Twitter
    class Create < ActionWithAppAuth

      def start
        render Authentication.set_by_twitter(params[:twitter_token], params[:twitter_secret])
        finish
      end
    end
  end
end
