class SearchesController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user

  def show
  end

  def create
    respond_to do |format|
      format.json do
        render :json => api_connect('jots/search.json', {:texts => params[:texts]}, 'get', true, false)
      end

      format.all { respond_not_found }
    end
  end

  def get_tag
    respond_to do |format|
      format.json do
        render :json => api_connect('me/tags/search.json', {:text => params[:text]}, 'get', false, true)
      end

      format.all { respond_not_found }
    end
  end
end
