class UsersController < ApplicationController

  def index
    respond_to do |format|

      format.json do
        render :json => api_connect('/users.json', params[:user], "get")
      end

      format.all { respond_not_found }
    end
  end

  def disfollowed_jot
    respond_to do |format|

      format.json do
        render :json => api_connect('/me/disfollowed_user.json', {:disfollowed_jot_id => params[:user_id]}, "post")
      end

      format.all { respond_not_found }
    end
  end
end