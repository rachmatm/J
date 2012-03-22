class NotificationController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user

  def index
    @notifications = api_connect('me/notifications', {}, 'get', false, true)['content']
  end
end
