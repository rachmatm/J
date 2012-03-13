Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, "8FTo0LBkSE0jAMNX0KcUg", "ke3obHG3YixzlxEYNzeMlUt4Htc72HJ1LMAAI476fYk"
end
