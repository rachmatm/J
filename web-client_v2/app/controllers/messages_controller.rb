class MessagesController < ApplicationController

  def create
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/messages.json", params[:message], "post")
      end

      format.all { respond_not_found }
    end
  end

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/messages.json", {}, "get")
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/messages/#{params[:message_id]}", {}, "delete")
      end

      format.all { respond_not_found }
    end
  end

  def mark_read
    respond_to do |format|

      format.json do
        render :json => api_connect("/me/messages/#{params[:message_id]}/mark_read.json", {}, "post")
      end

      format.all { respond_not_found }
    end
  end

  def reply
    respond_to do |format|
      
      format.json do
        render :json => api_connect("/me/messages/#{params[:message_id]}/reply.json", {:content => params[:content]}, "post")
      end

      format.all { respond_not_found }
    end
  end
end
