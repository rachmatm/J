module AuthenticationAction 

  class Create < ActionWithAppAuth

    # Validates the login and return authenticity_token if the username and
    # password is correct
    def start
      start_with_validates_params [:username, :password] do
        render Authentication.set @parameters[:username], @parameters[:password]
      end
    end
  end

  class Notify < ActionWithAppAuth
    def start
      start_with_validates_params [:email] do
        render Authentication.notify_forgot_password @parameters[:email], @client.url
      end
    end
  end

  class Update < ActionWithTokenAuth
    def start
      start_with_validates_params [:password] do
        render Authentication.reset_forgot_password @parameters[:password], @current_user.id
      end
    end
  end

  class Destroy < ActionWithTokenAuth
    # Immediately deletes token
    def start
      render Authentication.find(@current_user.id).unset
      finish
    end
  end
end
