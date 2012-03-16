class AccountSettingsContoller < ApplicationWithTokenController
  def update_email
    respond_to do |format|
      format.html do
        update_email_response = api_connect('account/update-email.json', {:email => params[:user][:email]}, "post", false, true)

        if update_email_response['failed'] == false
          redirect_to account_settings_path, :notice => update_email_response['notice']
        else
          flash[:errors] = update_email_response['errors']
          flash[:error] = update_email_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_password
    respond_to do |format|
      format.html do
        parameters = {:password => params[:user][:password], :old_password => params[:user][:old_password]}
        update_password_response = api_connect('account/update-password.json', parameters, "post", false, true)

        if update_password_response['failed'] == false and params[:user][:password_confirmation] == params[:user][:password]
          redirect_to account_settings_path, :notice => update_password_response['notice']
        else
          flash[:error] = (params[:user][:password] == params[:user][:password_confirmation]) ? update_password_response['error'] : "Your password confirmation doesn't match"
          flash[:errors] = update_password_response['errors']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_privacy
    respond_to do |format|
      format.html do
        update_privacy_response = api_connect('account/update-privacy.json', params[:user], "post", false, true)

        if update_privacy_response['failed'] == false
          redirect_to account_settings_path, :notice => update_privacy_response['notice']
        else
          flash[:errors] = update_privacy_response['errors']
          flash[:error] = update_privacy_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_your_stream
    respond_to do |format|
      format.html do
        update_your_stream_response = api_connect('account/update-your-stream.json', params[:user], "post", false, true)

        if update_your_stream_response['failed'] == false
          redirect_to account_settings_path, :notice => update_your_stream_response['notice']
        else
          flash[:errors] = update_your_stream_response['errors']
          flash[:error] = update_your_stream_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_default_post
    respond_to do |format|
      format.html do
        update_default_post_response = api_connect('account/update-default-post.json', params[:user], "post", false, true)

        if update_default_post_response['failed'] == false
          redirect_to account_settings_path, :notice => update_default_post_response['notice']
        else
          flash[:errors] = update_default_post_response['errors']
          flash[:error] = update_default_post_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_default_post
    respond_to do |format|
      format.html do
        update_default_post_response = api_connect('account/update-default-post.json', params[:user], "post", false, true)

        if update_default_post_response['failed'] == false
          redirect_to account_settings_path, :notice => update_default_post_response['notice']
        else
          flash[:errors] = update_default_post_response['errors']
          flash[:error] = update_default_post_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_connection
    respond_to do |format|
      format.html do

        update_connection_response = api_connect('account/update-connection.json', params[:user], "post", false, true)

        if update_connection_response['failed'] == false
          redirect_to account_settings_path, :notice => update_connection_response['notice']
        else
          flash[:errors] = update_connection_response['errors']
          flash[:error] = update_connection_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end

  def update_media_upload
    respond_to do |format|
      format.html do

        update_media_upload_response = api_connect('account/update-media-upload.json', params[:user], "post", false, true)

        if update_media_upload_response['failed'] == false
          redirect_to account_settings_path, :notice => update_media_upload_response['notice']
        else
          flash[:errors] = update_media_upload_response['errors']
          flash[:error] = update_media_upload_response['error']
          redirect_to account_settings_path
        end
      end
    end
  end
end
