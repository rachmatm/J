class AuthenticationsController < ApplicationController
  def create
    respond_to do |format|
      format.json do
        login_request = api_connect('/authentications.json', params[:authentication], "post", true, false)

        if login_request['failed'] === false
          set_token({:key => login_request['token']}, params[:remember_me])
        end

        render :json => login_request
      end

      format.all { respond_not_found }
    end
  end

  def destroy
    # Logging out, and deleting token in cramp server
    logout_response = api_connect('authentication/logout.json', {}, "get", false, true)
    flash[:notice] = logout_response['notice']
    unset_token
    redirect_to root_path
  end
end