FB_APP_ID = "275041155888679"
FB_SECRET_KEY = "524c56d2f500dec795310697cb457b2d"
FB_OAUTH_URL = "https://www.facebook.com/dialog/oauth?client_id=#{FB_APP_ID}&redirect_uri=http://localhost:3000/omniauth/authenticate_facebook&scope=email,read_stream,user_videos,publish_stream"

class FacebookHelper

  def self.upload_video(title, description, file, token)
    upload_video_request_url = "https://graph-video.facebook.com/me/videos?access_token=#{token}"

    parameters = {:title => title, :description => description, :file => File.open(file.path, 'r')}
    upload_video_request = Typhoeus::Request.new(upload_video_request_url,
                                                  :header => {'Content-Type' => file.content_type},
                                                  :method => :post,
                                                  :params => parameters)
    
    hydra = Typhoeus::Hydra.new
    hydra.queue(upload_video_request)
    hydra.run
    
    if upload_photo_request.response.body.present?
      ActiveSupport::JSON.decode upload_video_request.response.body
    else
      "Something went wrong, please try again"
    end
  end
  
  def self.upload_photo(description, file, token)

    parameters = {:message => description, :source => File.open(file.path, "r")}

    upload_photo_request_url = "https://graph.facebook.com/me/photos?access_token=#{token}"
    upload_photo_request = Typhoeus::Request.new(upload_photo_request_url,
                                                 :method => :post,
                                                 :params => parameters)

    hydra = Typhoeus::Hydra.new
    hydra.queue(upload_photo_request)
    hydra.run

    if upload_photo_request.response.body.present?
      ActiveSupport::JSON.decode upload_photo_request.response.body
    else
      "Something went wrong, please try again"
    end
  end
end
