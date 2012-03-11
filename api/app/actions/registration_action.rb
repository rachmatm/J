module RegistrationAction
  class Create < ActionWithAppAuth
    
    def start
      start_with_validates_params [:username, :email, :realname, :password] do
        Registration.set @parameters
      end
    end
  end
end