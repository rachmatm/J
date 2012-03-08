module AccountSettingsAction
  class UpdateEmail < ActionWithTokenAuth
    def start
      start_with_validates_params [:email] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdatePassword < ActionWithTokenAuth
    def start
      start_with_validates_params [:password, :old_password] do
        Authentication.find(@current_user.id).reset_password @parameters[:password], @parameters[:old_password]
      end
    end
  end

  class UpdatePrivacy < ActionWithTokenAuth
    def start
      start_with_validates_params [:jots_privacy, :show_location_privacy, :show_kudos_privacy] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdateYourStream < ActionWithTokenAuth
    def start
      start_with_validates_params [:hot_stream_home_page, :show_anonymous_jots] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdateDefaultPost < ActionWithTokenAuth
    def start
      start_with_validates_params [:auto_shorten_url, :auto_complete] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdateConnection < ActionWithTokenAuth
    def start
      start_with_validates_params [:facebook_connection, :facebook_always_cross_post, :twitter_connection, :twitter_always_cross_post] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdateMediaUpload < ActionWithTokenAuth
    def start
      start_with_validates_params [:upload_videos_to_facebook, :upload_videos_to_youtube, :upload_pictures_to_facebook] do
        User.find(@current_user.id).reset @parameters
      end
    end
  end

  class UpdateAvatar < ActionWithTokenAuth
    def start
      start_with_validates_params [:avatar, :selected_avatar, :avatar_coord_w, :avatar_coord_h, :avatar_coord_x, :avatar_coord_y] do
        User.find(@current_user.id).update_avatar @parameters
      end
    end
  end
end
