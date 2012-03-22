module UsersAction
  class Index < ActionWithAppAuth
    def start
      render User.get({:page => params[:page], :per_page => params[:per_page]})
      finish
    end
  end

  class Show < ActionWithTokenAuth
    def start
      render User.get :id => params[:id]
      finish
    end
  end
end