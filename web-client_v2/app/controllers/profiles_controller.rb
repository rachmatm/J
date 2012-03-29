class ProfilesController < ApplicationController
  def show
    respond_to do |format|

      format.json do
        render :json => api_connect('/me.json', params[:authentication], "get")
      end

      format.all { respond_not_found }
    end
  end

  def edit
    
  end

  def update

  end

  def destroy

  end
end