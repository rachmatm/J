class NestItemsController < ApplicationController

  def create

    respond_to do |format|

      format.json do
        render :json => api_connect("/me/nests/#{params[:nest_item][:nest_id]}/item.json", params[:nest_item], "post")
      end

      format.all { respond_not_found }
    end
  end

  def index

    respond_to do |format|

      format.json do
        render :json => api_connect("/me/nests/#{params[:nest_id]}/item.json", {}, "get")
      end

      format.all { respond_not_found }
    end
  end
end