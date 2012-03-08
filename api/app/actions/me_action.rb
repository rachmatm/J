module MeAction
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

  class CreatePrivateMessages < ActionWithTokenAuth
    def start
      @current_user.current_user_set_private_message @parameters
      finish
    end
  end

  class DeletePrivateMessages < ActionWithTokenAuth
  end

  class ReplyPrivateMessages < ActionWithTokenAuth
  end

  class IndexPrivateMessages < ActionWithTokenAuth
  end

  class ShowPrivateMessages < ActionWithTokenAuth
  end

  class AddJotThumbsUp < ActionWithTokenAuth
    def start
      start_with_validates_params [:jot_id] do
        render @current_user.current_user_set_thumbs_up_jot(@parameters[:jot_id])
      end
    end
  end

  class AddJotThumbsDown < ActionWithTokenAuth
    def start
      start_with_validates_params [:jot_id] do
        render @current_user.current_user_set_thumbs_down_jot(@parameters[:jot_id])
      end
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

  class AddFavoriteJot < ActionWithTokenAuth
    def start
      start_with_validates_params [:jot_id] do
        render @current_user.current_user_set_favorite_jot @parameters[:jot_id]
      end
    end
  end

  class IndexFavoriteJots < ActionWithTokenAuth
    def start
      render @current_user.current_user_get_favorite_jot
      finish
    end
  end

  class IndexNotifications < ActionWithTokenAuth
  end
end
