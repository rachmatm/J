module AdminAction
  
  module Auth
    
    class New < Action
      def start
        render_with_template :file => root_path('views/admin/auth/index.html.erb')
        finish
      end
    end

    class Create < Action
      before_start :check_request

      def check_request
        if data = Admin.login(params[:username], params[:password])
          request.session[:auth] = data._id

          halt 303, {'Location' => Server::Application.routes.url(:admin_clients_index)}
        else
          halt 303, {'Location' => '#unlogin'}
        end
      end 
    end

    class Destroy < Action
      before_start :getting_logged_out

      def getting_logged_out
        request.session[:auth] = nil
        halt 303, {'Location' => Server::Application.routes.url(:admin_auth_new)}
      end  
    end

    class Validate < Action
      before_start :validate

      def validate
        @admin = Admin.find request.session[:auth]
        yield
      rescue
        halt 303, {'Location' => Server::Application.routes.url(:admin_auth_new)}
      end
    end
  end


  module Clients
    
    class Index < AdminAction::Auth::Validate

      def start
        clients = Client.all
        render_with_template :file => root_path('views/admin/clients/index.html.erb'), :locals => {:clients => clients}
        finish
      end
    end

    class New < AdminAction::Auth::Validate
      def start
        client = Client.new
        render_with_template :file => root_path('views/admin/clients/new.html.erb'), :locals => {:client => client}
        finish
      end
    end

    class Create < AdminAction::Auth::Validate
      before_start :create_client

      def create_client
        client =  Client.create! :name => params[:name], :reset_password_confirmation_url => params[:reset_password_confirmation_url]

        halt 303, {'Location' => Server::Application.routes.url(:admin_clients_index)}
      end    
    end
    
    class Edit < AdminAction::Auth::Validate
      def start
        client = Client.find(params[:client_id])
        render_with_template :file => root_path('views/admin/clients/edit.html.erb'), :locals => {:client => client}
        finish
      end
    end

    class Update < AdminAction::Auth::Validate
      before_start :update_client

      def update_client
        app = Client.find(params[:client_id])
        app.update_attributes :name => params[:name]

        halt 303, {'Location' => Server::Application.routes.url(:admin_clients_index)}
      end
    end

    class Destroy < AdminAction::Auth::Validate
      before_start :destroy_client

      def destroy_client
        Client.find(params[:client_id]).destroy
        halt 303, {'Location' => Server::Application.routes.url(:admin_clients_index)}
      end 
    end

  end
end