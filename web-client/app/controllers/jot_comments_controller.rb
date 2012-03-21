class JotCommentsController < ApplicationController
  before_filter :validate_auth_user

  def index
    respond_to do |format|
      format.json do
        render :json => api_connect("/jots/#{params[:jot_id]}/comments.json", {:per_page => params[:per_page], :page => params[:page]}, 'get', false, true)
      end

      format.all { respond_not_found }
    end
  end

  def create
    respond_to do |format|
      format.json do
        render :json => api_connect("/me/jots/comments.json", params[:comment], 'post', true, true)
      end

      format.all { respond_not_found }
    end
  end
end