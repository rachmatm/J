class ApplicationWithTokenController < ApplicationController
  before_filter :validate_token
  
  def validate_token
    if token_auth?
      set_token :key => get_token[:key]
      request_profile = api_connect('me.json', {}, "get", false, true)
      @current_user = request_profile['content']
      
      if request_profile["failed"] === true
        unset_token
        redirect_to root_path
      elsif not @current_user.present?
        render_500 unless @current_user.present?
      end

    elsif not request.path == root_path
      unset_token
      redirect_to root_path
    end
  end
end
