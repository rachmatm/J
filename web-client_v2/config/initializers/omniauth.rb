Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '394250970587254', '15b4fa1f393157e4b2943ab7fcb61cb5', :scope => ''
  provider :twitter, "8FTo0LBkSE0jAMNX0KcUg", "ke3obHG3YixzlxEYNzeMlUt4Htc72HJ1LMAAI476fYk"
  provider :facebook, '394250970587254', '15b4fa1f393157e4b2943ab7fcb61cb5', :scope => 'email,offline_access,read_stream,publish_stream,user_videos', :name => 'facebook_connection'
  provider :twitter, "8FTo0LBkSE0jAMNX0KcUg", "ke3obHG3YixzlxEYNzeMlUt4Htc72HJ1LMAAI476fYk", :name => 'twitter_connection'
end