GOOGLE_CLIENT_ID = "1056251033952.apps.googleusercontent.com"
GOOGLE_CLIENT_SECRET = "fSNrvlAtliOnQXx3doMVod7e"
GOOGLE_YT_DEV_KEY = "AI39si6OyQw9QKnPeiU5Y29tBgm4WjmfZyB860G-CfosFyUZpPsJO-ayiIgDFyNnIQijTGuLuJ86Zbx1VN3aH8LqN-Jglg5iXg"
GOOGLE_OAUTH_URL = "https://accounts.google.com/o/oauth2/auth?" + 
                   "client_id=#{GOOGLE_CLIENT_ID}&" +
                   "redirect_uri=http://localhost:3000/oauth2callback&" +
                   "scope=https://gdata.youtube.com&" +
                   "response_type=code&" +
                   "access_type=offline"

class GoogleHelper
  def self.upload_video(access_token, refresh_token, token_expires_at, title, description, file)
    youtube_parameters = {:client_access_token => access_token,
                  :client_refresh_token => refresh_token,
                  :client_id => GOOGLE_CLIENT_ID,
                  :client_secret => GOOGLE_CLIENT_SECRET ,
                  :dev_key => GOOGLE_YT_DEV_KEY,
                  :client_token_expires_at => token_expires_at}

    client = YouTubeIt::OAuth2Client.new(youtube_parameters)
    video_parameters = {:title => title, :description => description, :category => 'People',:keywords => %w[people social media]}
    video_info = client.video_upload(File.open(file.path), video_parameters)

    return video_info
  end
end
