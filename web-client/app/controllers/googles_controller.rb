require 'oauth2'

class GooglesController < ApplicationWithTokenController
  def upload_video

  end

  def upload_video_action
    parameters = {:client_access_token => @current_user['google_user_token'],
                  :client_refresh_token => @current_user['google_user_refresh_token'],
                  :client_id => GOOGLE_CLIENT_ID,
                  :client_secret => GOOGLE_CLIENT_SECRET ,
                  :dev_key => GOOGLE_YT_DEV_KEY,
                  :client_token_expires_at => Time.parse(@current_user['google_user_token_expires_at'])}

    client = YouTubeIt::OAuth2Client.new(parameters)
    video_parameters = {:title => params[:title], :description => params[:description], :category => params[:category],:keywords => params[:keywords].split(", ")}
    client.video_upload(File.open(params[:files].path), video_parameters)
    redirect_to upload_video_googles_path, :notice => "You have successfully uploaded the video"
  rescue
    client.refresh_access_token! if client.present? and @current_user['google_user_refresh_token'].present?
    redirect_to upload_video_googles_path, :error => "Something went wrong, or some fields are empty, please try again"
  end
end
