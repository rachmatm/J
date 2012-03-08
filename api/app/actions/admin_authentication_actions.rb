module AdminAuthenticationActions
  class New < Action
    def start
      request.session[:test] = "asd"

      render_with_template :file => root_path('views/admin_authentication/index.html.erb')
      finish
    end  
  end
  
  class Create < Action
    before_start :check_request
    
    def check_request
      if admin_login = Admin.login(params[:username], params[:password])
        self.auth_admin.login admin_login.id.to_s
        halt 303, {'Location' => Server::Application.routes.url(:admin_clients)}
      else
        halt 303, {'Location' =>  Server::Application.routes.url(:admin_login_new)}
      end
    end    
  end
  
  class Delete < Action
    before_start :getting_logged_out
    
    def getting_logged_out
      self.auth_admin.logout!
      halt 303, {'Location' => Server::Application.routes.url(:admin_login_new)}  
    end  
  end  
end  
