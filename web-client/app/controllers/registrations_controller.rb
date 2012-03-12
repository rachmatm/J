class RegistrationsController < ApplicationController
  
  def create

    respond_to do |format|
      format.json do
        render :json => {:ok => 'yes'}
#        if not verify_recaptcha
#          render :json => {:error => "Please try again recaptcha is invalid", :failed => true, :errors => []}, :content_type => 'application/json'
#        else
#          signup_request = api_connect "registration.json", params[:registration], "post", true
#
#          if signup_request['failed'] === false
#            set_token({:key => signup_request['token']})
#          else
#            render :json => signup_request, :content_type => 'application/json'
#          end
#        end
      end

      format.all { respond_not_found }
    end
  end
end