class JotsController < ApplicationController

  def create
    respond_to do |format|

      format.json do
        render :json => api_connect('/me/jots.json', params[:jot], "post")
      end

      format.all { respond_not_found }
    end
  end

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect('/me/jots.json', params[:jot], "get")
      end

      format.all { respond_not_found }
    end
  end

  def favorite
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/favorites.json", {}, "post")
      end

      format.all { respond_not_found }
    end
  end

  def thumbsup
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/thumbsup.json", {}, "post")
      end

      format.all { respond_not_found }
    end
  end

  def thumbsdown
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/thumbsdown.json", {}, "post")
      end

      format.all { respond_not_found }
    end
  end

  def rejot
    respond_to do |format|
      
      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/rejot.json", {}, "post")
      end

      format.all { respond_not_found }
    end
  end

 
end
