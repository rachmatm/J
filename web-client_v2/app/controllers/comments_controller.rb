class CommentsController < ApplicationController

  def create
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/comments.json", params[:comment], "post")
      end

      format.all { respond_not_found }
    end
  end

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/jots/#{params[:jot_id]}/comments.json", params[:comment], "get")
      end

      format.all { respond_not_found }
    end
  end
end