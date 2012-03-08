module AdminClientsAction
  class Index < ActionWithAdminAuth
    
    def start
      clients = Client.all
      render_with_template :file => root_path('views/admin_clients/index.html.erb'), :locals => {:clients => clients}
      finish
    end    
  end
  
  class New < ActionWithAdminAuth
    
    def start
      client = Client.new

      render_with_template :file => root_path('views/admin_clients/new.html.erb'), :locals => {:client => client}
      
      finish
    end    
  end
  
  class Create < ActionWithAdminAuth
    before_start :add_new_client
    
    def add_new_client
      client =  Client.create! :name => params[:name], :reset_password_confirmation_url => params[:reset_password_confirmation_url]

      halt 303, {'Location' => Server::Application.routes.url(:admin_clients)}
    end    
  end
  
  class Delete < ActionWithAdminAuth
    before_start :add_new_client
    
    def add_new_client
      Client.find(params[:app_id]).destroy
      halt 303, {'Location' => Server::Application.routes.url(:admin_clients)}
    end    
  end
  
  class Edit < ActionWithAdminAuth
    def start
      client = Client.find(params[:app_id])
      render_with_template :file => root_path('views/admin_clients/edit.html.erb'), :locals => {:client => client}
      finish
    end    
  end
  
  class Update < ActionWithAdminAuth
    before_start :edit_client
    
    def edit_client
      app = Client.find(params[:app_id])
      app.update_attributes :name => params[:name]
       
      halt 303, {'Location' => Server::Application.routes.url(:admin_clients)}
    end    
  end    
end  

  
