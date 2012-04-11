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

    class Delete < ActionWithTokenAuth

      def start
        render @current_user.current_user_unset_jot params[:id], @current_user.id
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
          render Jot.get_comments params[:jot_id], params
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
        render @current_user.current_user_unset_connections params[:connection_id]
        finish
      end
    end

    class Index < ActionWithTokenAuth

      def start
        render @current_user.current_user_connections params
        finish
      end
    end

    class Update < ActionWithTokenAuth

      def start
        render @current_user.current_user_reset_connections params[:connection_id], params
        finish
      end
    end
  end

  module NestAction
    
    class Index < ActionWithTokenAuth

      def start
        render @current_user.get_nest params
        finish
      end
    end

    class Create < ActionWithTokenAuth

      def start
        render @current_user.set_nest params
        finish
      end
    end

    class Destroy < ActionWithTokenAuth

      def start
        render @current_user.unset_nest params[:nest_id]
        finish
      end
    end

    class Update < ActionWithTokenAuth

      def start
        render @current_user.reset_nest params[:nest_id], params
        finish
      end
    end

    module ItemAction

      class Create < ActionWithTokenAuth

        def start
          render @current_user.set_nest_item params
          finish
        end
      end

      class Index < ActionWithTokenAuth

        def start
          render Nest.get_item params[:nest_id]
          finish
        end
      end
    end
  end

  module ClipAction

    class Create < ActionWithTokenAuth

      def start
        render @current_user.set_clip params
        finish
      end
    end

    class Destroy < ActionWithTokenAuth

      def start
      end
    end
  end

  module Message

    class Create < ActionWithTokenAuth

      def start
        render @current_user.current_user_set_message params[:receiver], params[:subject], params[:content]
        finish
      end
    end

    class Delete < ActionWithTokenAuth

      def start
        render @current_user.current_user_unset_message params[:message_id]
        finish
      end
    end

    class Index < ActionWithTokenAuth

      def start
        render @current_user.current_user_get_message
        finish
      end
    end

    class Show < ActionWithTokenAuth

      def start
        render @current_user.current_user_get_single_message params[:message_id]
        finish
      end
    end

    class MarkRead < ActionWithTokenAuth

      def start
        render @current_user.current_user_set_message_mark_read params[:message_id]
        finish
      end
    end

    module Reply

      class Create < ActionWithTokenAuth

        def start
          render @current_user.current_user_set_message_reply params[:message_id], params[:content]
          finish
        end
      end

      class Index < ActionWithTokenAuth

        def start
          render @current_user.current_user_get_message_reply params[:message_id]
          finish
        end
      end
    end
  end

  module UserAction
    class Index < ActionWithAppAuth

      def start
        render User.get :id => params[:id]
        finish
      end
    end
  end
end
