module ProfilesAction
  class Update < ActionWithTokenAuth
    def start
      start_with_validates_params [:url, :bio, :location, :username, :realname, :longitude, :latitude, :avatar, :selected_avatar] do
        @current_user.reset @parameters
      end
    end
  end

  class Show < ActionWithTokenAuth
    def start
      render User.get(@current_user.id)
      finish
    end
  end
end
