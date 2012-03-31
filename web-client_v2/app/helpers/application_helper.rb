module ApplicationHelper
  def show_alert_message(vars = {})
    local_vars = {:info => nil, :error => nil, :errors => [], :notice => nil}.merge vars
    render :partial => 'shared/alert_message', :locals => local_vars
  end
end