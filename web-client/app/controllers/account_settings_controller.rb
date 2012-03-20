class AccountSettingsContoller < ApplicationWithTokenController
  def update_email
    respond_to do |format|
      format.json do
        update_email_response = api_connect('account/update-email.json', {:email => params[:user][:email]}, "post", false, true)

        render :json => update_email_response
      end
    end
  end

  def update_password
    respond_to do |format|
      format.json do
        parameters = {:password => params[:user][:password], :old_password => params[:user][:old_password]}
        update_password_response = api_connect('account/update-password.json', parameters, "post", false, true)

        render :json => update_password_response
      end
    end
  end

  def update_privacy
    respond_to do |format|
      format.json do
        update_privacy_response = api_connect('account/update-privacy.json', params[:user], "post", false, true)

        render :json => update_privacy_response
      end
    end
  end

  def update_your_stream
    respond_to do |format|
      format.json do
        update_your_stream_response = api_connect('account/update-your-stream.json', params[:user], "post", false, true)
        
        render :json => update_your_stream_response
      end
    end
  end

  def update_default_post
    respond_to do |format|
      format.json do
        update_default_post_response = api_connect('account/update-default-post.json', params[:user], "post", false, true)

        render :json => update_default_post_response
      end
    end
  end

  def update_connection
    respond_to do |format|
      format.json do
        update_connection_response = api_connect('account/update-connection.json', params[:user], "post", false, true)

        render :json => update_connection_response
      end
    end
  end

  def update_media_upload
    respond_to do |format|
      format.json do

        update_media_upload_response = api_connect('account/update-media-upload.json', params[:user], "post", false, true)

        render :json => update_media_upload_response
      end
    end
  end
end
