module MeAction

  class Show < ActionWithTokenAuth
    def start
      render @current_user.get_my_attributes
      finish
    end
  end

  class Update < ActionWithTokenAuth
    def start
      render @current_user.set_my_attributes params
      finish
    end
  end

  module JotAction
    class Create < ActionWithTokenAuth

      def start
        render @current_user.current_user_set_jot params
        finish
      end
    end

    class Index < ActionWithTokenAuth

      def start
        render @current_user.current_user_get_jot params
        finish
      end
    end

    module Thumbsup

      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_thumbs_up_jot params[:jot_id]
          finish
        end
      end
    end

    module Thumbsdown

      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_thumbs_down_jot params[:jot_id]
          finish
        end
      end
    end

    module Favorite

      class Index < ActionWithTokenAuth

        def start
          render @current_user.current_user_get_favorite_jot params[:limit]
          finish
        end
      end

      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_favorite_jot params[:jot_id]
          finish
        end
      end
    end

    module Rejot
      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_rejot params[:jot_id]
          finish
        end
      end
    end

    module CommentAction

      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_jot_comments params[:jot_id], params
          finish
        end
      end

      class Index < ActionWithTokenAuth

        def start
          render Comment.get_comments params[:jot_id]
          finish
        end
      end
    end

  end

  module ConnectionAction

    class Create < ActionWithTokenAuth

      def start
        render @current_user.current_user_set_connections params
        finish
      end
    end

    class Destroy < ActionWithTokenAuth

      def start
        render @current_user.current_user_unset_connections params[:id]
        finish
      end
    end
  end
end
