module RegistrationAction

  class Create < ActionWithAppAuth
    def start
      render Registration.set params
      finish
    end
  end
end