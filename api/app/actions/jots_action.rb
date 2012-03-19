module JotsAction
  
  class Index < Action
    def start
      render Jot.get params
      finish
    end
  end

#  class IndexShowMore < ActionWithTokenAuth
#    def start
#      render Jot.get_more(params[:skip], params[:limit])
#      finish
#    end
#  end
#
#  class Show < ActionWithTokenAuth
#    def start
#      render Jot.get_single(params[:id]) if params[:id] != 'favicon'
#      finish
#    end
#  end
#
#  class Create < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:title, :jot_detail, :jot, :attachments, :location, :location_latitude, :location_longitude, :tags] do
#        @current_user.current_user_set_jot @parameters
#      end
#    end
#  end
#
#  class Update < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:detail, :jot, :clip, :location, :latitude, :longitude, :tags] do
#        Jot.update_jot @parameters, params[:id]
#      end
#    end
#  end
#
#  class Destroy < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:id] do
#        @current_user.current_user_unset_jot params[:id]
#      end
#    end
#  end
#
#  # Favorites Section of Jots
#
#  class FavoritesIndex < ActionWithTokenAuth
#    def start
#      render @current_user.current_user_get_favorite_jot
#      finish
#    end
#  end
#
#  class FavoritesCreate < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id] do
#        render @current_user.current_user_set_favorite_jot @parameters[:jot_id]
#      end
#    end
#  end
#
#  class FavoritesDestroy < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id] do
#        render @current_user.current_user_unset_favorite_jot @parameters[:jot_id]
#      end
#    end
#  end
#
#  # Like Section of Jots
#
#  class LikeCreate < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id] do
#        render @current_user.current_user_set_thumbs_up_jot(@parameters[:jot_id])
#      end
#    end
#  end
#
#  class DislikeCreate < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id] do
#        render @current_user.current_user_set_thumbs_down_jot(@parameters[:jot_id])
#      end
#    end
#  end
#
#  # Comments Section of Jots
#
#  class CommentsCreate < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id, :content] do
#        render Comment.set @current_user.id, @parameters[:jot_id], @parameters[:content]
#        finish
#      end
#    end
#  end
#
#  class CommentsDestroy < ActionWithTokenAuth
#    def start
#      start_with_validates_params [:jot_id, :comment_id] do
#        render Comment.unset @parameters[:jot_id], @parameters[:comment_id]
#      end
#    end
#  end
end
