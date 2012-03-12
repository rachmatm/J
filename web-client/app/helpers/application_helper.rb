module ApplicationHelper
  
  def show_alert_message(vars = {})
    render :partial => 'shared/alert_message', :locals => vars
  end
end
