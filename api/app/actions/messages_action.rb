module MessagesAction
  class CreatePrivateMessages < ActionWithTokenAuth
    def start
      start_with_validates_params [:message, :sender_id, :recipient_id] do
        @current_user.current_user_set_private_message @parameters
      end
    end
  end
  
  class ReplyPrivateMessages < ActionWithTokenAuth
    def start
      start_with_validates_params [:message, :sender_id, :recipient_id, :topic_id] do
        @current_user.current_user_set_private_message @parameters
      end
    end
  end

  
  class DeletePrivateMessages < ActionWithTokenAuth
    def start
      start_with_validates_params [:message_id] do
        @current_user.current_user_unset_private_message params[:message_id]
      end
    end
  end
 
  class IndexPrivateMessages < ActionWithTokenAuth
    def start
      start_with_validates_params [:user_id] do
        @current_user.current_user_get_private_message @parameters
      end
    end
  end
  
  class ShowPrivateMessages < ActionWithTokenAuth
    def start
      start_with_validates_params [:id] do
        @current_user.current_user_show_private_message @parameters
      end
    end
  end
  
end
