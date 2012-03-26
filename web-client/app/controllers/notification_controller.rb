class NotificationController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user

  def index
    @notifications = api_connect('me/notifications', {}, 'get', false, true)['content']
  end

  def destroy
    respond_to do |format|
      format.json do
        render :json => api_connect("me/notifications/#{params[:notification_id]}", {:type => params[:type]}, 'delete', false, true)
      end

      format.all { respond_not_found }
    end
  end
end
