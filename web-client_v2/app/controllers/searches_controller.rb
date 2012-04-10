class SearchesController < ApplicationController
  
  def index
    respond_to do |format|

      format.json do
        render :json => api_connect('/search.json', {:keyword => params[:keyword], :type => params[:type]}, "get")
      end

      format.all { respond_not_found }
    end
  end
end
