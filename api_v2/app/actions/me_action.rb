module MeAction

  class Show < ActionWithTokenAuth
    def start
      render @current_user.get_my_attributes
      finish
    end
  end

  module Jot
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
  end

  
end