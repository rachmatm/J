module MeAction

# Users
# ------------------------------------------------------------------------

  class Index < ActionWithTokenAuth
    def start
      render @current_user.get
      finish
    end
  end

  class Update < ActionWithTokenAuth
    def start
      render @current_user.reset params
      finish
    end
  end

  class Search < ActionWithTokenAuth
    def start
      render @current_user.search params[:text]
      finish
    end
  end

# Jots
# ------------------------------------------------------------------------

  class CreateJot < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_jot params
      finish
    end
  end

  class CreateTagOrFindOrCreate < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_tags params[:tag_names]
      finish
    end
  end

  class ShowJot < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_jot :id => params[:id]
      finish
    end
  end

  class IndexJot < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_jot(params)
      finish
    end
  end

  class DeleteJot < ActionWithTokenAuth
    def start
      render @current_user.current_user_unset_jot params[:id]
      finish
    end
  end

  class CreateJotComment < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_jot_comment params[:jot_id], params
      finish 
    end
  end

  class IndexJotComment < ActionWithTokenAuth
    def start
      render Jot.get_comment(params[:jot_id], params)
      finish
    end
  end

# Nest
# ------------------------------------------------------------------------

  class CreateNest < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_nest params
      finish
    end
  end

  class UpdateNest < ActionWithTokenAuth
    def start
      render @current_user.current_user_reset_nest params[:id], params
      finish
    end
  end

  class ShowNest < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_nest :id => params[:id]
      finish
    end
  end

  class IndexNest < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_nest :per_page => params[:per_page], :page => params[:page]
      finish
    end
  end

  class DeleteNest < ActionWithTokenAuth
    def start
      render @current_user.current_user_unset_nest params[:id]
      finish
    end
  end

# Tags
# ------------------------------------------------------------------------

  class SubscribeTags < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_tags params[:tags]
      finish
    end
  end

  class UnsubscribeTags < ActionWithTokenAuth
    def start
      render @current_user.current_user_unset_tags params[:tags]
      finish
    end
  end

  class IndexTags < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_tags :per_page => params[:per_page], :page => params[:page]
      finish
    end
  end

  class SearchTags < ActionWithTokenAuth
    def start
      render @current_user.current_user_search_tags params[:text]
      finish
    end
  end

# Private Messages
# ------------------------------------------------------------------------

  class CreatePrivateMessages < ActionWithTokenAuth
  end

  class DeletePrivateMessages < ActionWithTokenAuth
  end

  class ReplyPrivateMessages < ActionWithTokenAuth
  end

  class IndexPrivateMessages < ActionWithTokenAuth
  end

  class ShowPrivateMessages < ActionWithTokenAuth
  end

# Thumbs
# ------------------------------------------------------------------------

  class AddJotThumbsUp < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_thumbs_up_jot params[:id]
      finish
    end
  end

  class AddJotThumbsDown < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_thumbs_down_jot params[:id]
      finish
    end
  end

  class IndexJotThumbsUp < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_thumbs_up_jot params[:jot_id]
      finish
    end
  end

  class IndexJotThumbsDown < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_thumbs_down_jot params[:jot_id]
      finish
    end
  end

# Favorites
# ------------------------------------------------------------------------

  class AddFavoriteJot < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_favorite_jot params[:jot_id]
      finish
    end
  end

  class IndexFavoriteJots < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_favorite_jot
      finish
    end
  end


# Favorites
# ------------------------------------------------------------------------
  class AddRejot < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_rejot params[:jot_id]
      finish
    end
  end


# Notifications
# ------------------------------------------------------------------------

  class IndexNotifications < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_notifications
      finish
    end
  end

  class DeleteNotifications < ActionWithTokenAuth
    def start
      render @current_user.current_user_unset_notifications params[:id], params[:type]
      finish
    end
  end

# Facebook
# ------------------------------------------------------------------------

  class AddFacebookAccountDialog < ActionWithTokenAuth
    before_start :facebook_oauth_dialog

    def facebook_oauth_dialog
      halt 302, {'Location' => FB_ADD_OAUTH_URL + "&state=#{@current_user.token}"}
    end
  end

  class AddFacebookAccount < Action
    before_start :facebook_authentication

    def facebook_authentication
      halt 302, {'Location' => User.where(:token => params[:state]).first.current_user_add_facebook_account(params[:code])}
    end
  end

  class IndexFacebookWall < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_facebook_wall
      finish
    end
  end

  class CreateFacebookStatus < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_facebook_status params[:message]
      finish
    end
  end

# Twitter
# ------------------------------------------------------------------------

  class AddTwitterAccount < ActionWithTokenAuth
    def start
      start_with_validates_params [:oauth_token, :oauth_secret, :twitter_id, :username, :realname] do
        render @current_user.current_user_add_twitter_account @parameters
      end
    end
  end

  class IndexTwitterTimeline < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_twitter_timeline
      finish
    end
  end

  class CreateTwitterStatus < ActionWithTokenAuth
    def start
      render @current_user.current_user_set_twitter_status params[:status]
      finish
    end
  end

# Google
# ------------------------------------------------------------------------

  class AddGoogleAccountDialog < ActionWithTokenAuth
    before_start :facebook_oauth_dialog

    def facebook_oauth_dialog
      halt 302, {'Location' => GOOGLE_ADD_OAUTH_URL + "&state=#{@current_user.token}"}
    end
  end

  class AddGoogleAccount < Action
    before_start :google_authentication

    def google_authentication
      halt 302, {'Location' => User.where(:token => params[:state]).first.current_user_add_google_account(params[:code])}
    end
  end
end
