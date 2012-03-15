class FacebooksController < ApplicationWithTokenController
  def wall
    @wall = api_connect('me/facebook/wall.json', {}, 'get', false, true)['content']
  end

  def status
    
  end

  def post_status
    post_facebook_status_response = api_connect('me/facebook/status.json', params, 'post', false, true)

    if post_facebook_status_response['failed'] === false
      redirect_to status_facebooks_path, :notice => post_facebook_status_response['notice']
    else
      redirect_to status_facebooks_path, :notice => post_facebook_status_response['notice']
    end
  end

  def upload_photo

  end
  
  def upload_photo_create

    parameters = {:message => params[:description], :source => File.open(params[:photo].path, "r")}

    upload_photo_request_url = "https://graph.facebook.com/me/photos?access_token=#{@current_user['facebook_token']}"
    upload_photo_request = Typhoeus::Request.new(upload_photo_request_url,
                                                 :method => :post,
                                                 :params => parameters)

    hydra = Typhoeus::Hydra.new
    hydra.queue(upload_photo_request)
    hydra.run

    if upload_photo_request.response.body.present?
      redirect_to root_path, :notice => "You have successfully uploaded your photo"
    else
      redirect_to upload_photo_facebooks_path, :error => "Something went wrong, please try again"
    end
  end

  def upload_video
    
  end

  def upload_video_create

    file = params[:files]

    filename = file.original_filename.gsub(/[\w\s\d\-\?]+\.(\w+)$/, "#{SecureRandom.hex(5)}" + '.\1')
    directory = "#{Rails.root}/tmp/"

    path = File.join(directory, filename)

    File.open(path, "wb") { |f| f.write(file.read) }

    parameters = {:file => File.open(path, "rb")}

    upload_video_request_url = "https://graph-video.facebook.com/me/videos?access_token=#{@current_user['facebook_token']}" +
                               "&title=#{URI.escape params[:title]}" + 
                               "&description=#{URI.escape params[:description]}"

    upload_video_request = Typhoeus::Request.new(upload_video_request_url,
                                                 :header => {'Content-Type' => params[:files].content_type},
                                                 :method => :post,
                                                 :params => parameters)

    hydra = Typhoeus::Hydra.new
    hydra.queue(upload_video_request)
    hydra.run

    if upload_video_request.response.body['id'].present?
      redirect_to root_path, :notice => "You have successfully uploaded your video"
    else
      redirect_to upload_video_facebooks_path, :error => "Something went wrong, please try again"
    end
  end
end
