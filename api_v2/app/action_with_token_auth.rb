class ActionWithTokenAuth < Action
  before_start :validate_token

  def validate_token
    if params[:token].present? and @current_user = User.where(:token => params[:token]).first
      yield
    else
      halt 200, html_header, JsonizeHelper.format( :error => "Please login to do this.", :failed => true )
    end
  end
end
