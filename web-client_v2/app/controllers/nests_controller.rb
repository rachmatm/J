class NestsController < ApplicationController

  def create

    respond_to do |format|

      format.json do
        render :json => api_connect('/me/nests.json', params[:nest], "post")
      end

      format.all { respond_not_found }
    end
  end

  def index

    respond_to do |format|

      format.json do
        render :json => api_connect('/me/nests.json', {}, "get")
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/#{params[:id]}/nests.json", {}, "delete")
      end

      format.all { respond_not_found }
    end
  end

  def update
    
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/#{params[:nest_id]}/nests.json", params[:nest], "put")
      end

      format.all { respond_not_found }
    end
  end
end