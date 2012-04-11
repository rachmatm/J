class UsersController < ApplicationController

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect('/users.json', params[:user], "get")
      end

      format.all { respond_not_found }
    end
  end
end