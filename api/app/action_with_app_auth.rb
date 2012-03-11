class ActionWithAppAuth < Action
  before_start :validate_app
  
  # Checking whether the app_id and app_secret match or not
  def validate_app
    @client = Client.where({:secret_key => params[:secret_key]}).find(params[:app_id])
    yield
  rescue  
    halt 200, get_content_type, JsonizeHelper.format( :status => 401, :error => "App_id or secret_key invalid", :failed => true )
  end
end