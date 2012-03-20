class JotsController < ApplicationController
  layout 'application3'
  before_filter :validate_auth_user
  
  def new

  end

  def create
    respond_to do |format|
      format.html do
        uploader = MediaUploader.new
        uploader.store! params[:files]
        params.merge!({:files => File.open(uploader.path, 'r')})
        jot_create_response = api_connect('me/jots.json', params, 'post', false, true)
        uploader.remove!
        redirect_to new_jot_path, :notice => jot_create_response['notice']
      end

      format.json do
        render :json => api_connect('me/jots.json', params[:jot], 'post', false, true)
      end

      format.all { respond_not_found }
    end
  end

#  def create
#    jot_create_response = api_connect('me/jots.json', params, 'post', false, true)
#    facebook_post_status_response = api_connect('me/facebook/status.json', { :message => params[:title] }, 'post', false, true) if @current_user['facebook_id'].present?
#    twitter_post_status_response = api_connect('me/twitter/status.json', { :status => params[:title] }, 'post', false, true) if @current_user['twitter_id'].present?
#
#    if @current_user['facebook_id'].present? and @current_user['upload_videos_to_facebook'] == true
#      file = params[:files]
#
#      filename = file.original_filename.gsub(/[^\.]+\.(\w+)/, "#{SecureRandom.hex(5)}" + '.\1')
#      directory = "#{Rails.root}/tmp/"
#
#      path = File.join(directory, filename)
#
#      File.open(path, "wb") { |f| f.write(file.read) }
#
#      parameters = {:file => File.open(path, "rb")}
#
#      upload_video_request_url = "https://graph-video.facebook.com/me/videos?access_token=#{@current_user['facebook_token']}" +
#                                 "&title=#{URI.escape params[:title]}" +
#                                 "&description=#{URI.escape params[:detail]}"
#
#      upload_video_request = Typhoeus::Request.new(upload_video_request_url,
#                                                   :header => {'Content-Type' => params[:files].content_type},
#                                                   :method => :post,
#                                                   :params => parameters)
#
#      hydra = Typhoeus::Hydra.new
#      hydra.queue(upload_video_request)
#      hydra.run
#    end
#
#    if @current_user['google_user_token'].present? and @current_user['upload_videos_to_youtube'] == true
#      parameters = {:client_access_token => @current_user['google_user_token'],
#                    :client_refresh_token => @current_user['google_user_refresh_token'],
#                    :client_id => GOOGLE_CLIENT_ID,
#                    :client_secret => GOOGLE_CLIENT_SECRET ,
#                    :dev_key => GOOGLE_YT_DEV_KEY,
#                    :client_token_expires_at => Time.parse(@current_user['google_user_token_expires_at'])}
#
#      client = YouTubeIt::OAuth2Client.new(parameters)
#      video_parameters = {:title => params[:title], :description => params[:detail], :category => 'People',:keywords => %w['jotky' 'test']}
#      debugger
#      client.video_upload(File.open(params[:files].path), video_parameters)
#    end
#
#    if jot_create_response['failed'] === false
#      redirect_to root_path, :notice => "Your jot was posted"
#    else
#      redirect_to new_jot_path
#    end
#  rescue
#    client.refresh_access_token! if client.present? and @current_user['google_user_refresh_token'].present?
#    redirect_to :action => 'new', :error => "Something went wrong, or some fields are empty, please try again"
#  end

  #def create
    #respond_to do |format|

      #format.json do
        #debugger
      #end

      #format.all { respond_not_found }
    #end
  #end

  def index
    
    respond_to do |format|
      format.json do
        unless @current_user.present?
          render :json => api_connect('jots/index.json', params[:jot], 'get', true)
        else
          render :json => api_connect('me/jots.json', params[:jot], 'get', true, true)
        end
      end

      format.html do
      end

      format.all { respond_not_found }
    end
  end
end
