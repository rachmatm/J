class ProfilesController < ApplicationController
  def show
    respond_to do |format|

      format.json do
        render :json => api_connect('/me.json', {}, "get")
      end
      
      format.all { respond_not_found }
    end
  end

  def edit
    
  end

  def update
    respond_to do |format|

      format.json do
        render :json => api_connect('/me.json', params[:profile], "post")
      end

      format.all { respond_not_found }
    end
  end

  def destroy

  end
end