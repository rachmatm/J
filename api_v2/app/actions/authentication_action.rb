module AuthenticationAction

  class Create < ActionWithAppAuth

    def start
      render Authentication.set(params[:username], params[:password])
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