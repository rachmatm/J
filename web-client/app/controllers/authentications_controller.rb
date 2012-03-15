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

  def forgot_password
    redirect_to root_path, :notice => "You already logged in" if token_auth?

    if params[:token].present? and params[:password].present?
      set_token({:key => params[:token]})
      reset_password_request = api_connect('authentication/reset_forgot_password.json', { :password => params[:password] }, "post", false, true)
      redirect_to account_settings_path, :notice => reset_password_request['notice']
    end
  end

  def notify_forgot_password

    respond_to do |format|
      format.json do
        notify_password_request = api_connect('authentication/notify_forgot_password.json', { :email => params[:email]}, "post", true, false)

        render :json => notify_password_request
      end

      format.all { respond_not_found }
    end
  end
end
