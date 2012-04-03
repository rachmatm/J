class ConnectionsController < ApplicationController

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect('/me/connections.json', {:provider => params[:provider], :allowed => params[:allowed]}, "get")
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/#{params[:connection_id]}/connections.json", {}, "delete")
      end

      format.all { respond_not_found }
    end
  end

  def create

    respond_to do |format|
      format.json do
        
        api_respond = {}

        params[:connection].each do |conn_id, parameters|
          api_respond = api_connect("/me/#{conn_id}/connections.json", parameters, "put")

          break if api_respond['failed'] === true
        end

        render :json => api_respond
      end

      format.all { respond_not_found }
    end
  end
end