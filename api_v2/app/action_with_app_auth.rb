class ActionWithAppAuth < Action
  before_start :validate_app
  
  def validate_app
    @client = Client.where({:secret_key => params[:secret_key]}).find(params[:app_id])
    yield
  rescue
    halt 200, html_header('json'), JsonizeHelper.format( :status => 401, :error => "app_id or secret_key invalid", :failed => true )
  end
end