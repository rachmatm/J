module CommentsAction
  class Create < ActionWithTokenAuth
    def start
      start_with_validates_params [:jot_id, :content] do
        render Comment.jot_comment_set @current_user.id, @parameters[:jot_id], @parameters[:content]
        finish
      end
    end
  end
  
  class Destroy < ActionWithTokenAuth
    def start
      start_with_validates_params [:jot_id, :comment_id] do
        render Comment.jot_comment_unset @parameters[:jot_id], @parameters[:comment_id]
      end
    end
  end
end
