# https://github.com/joshbuddy/http_router
HttpRouter.new do
  # Registration
  post('/registration(.:format)').to(RegistrationAction::Create)

  get('/users(.:format)').to(UsersAction::Index)
  get('/users/(:id)(.:format)').to(UsersAction::Show)

  # Authentication
  post('/authentications(.:format)').to(AuthenticationAction::Create)
  add('/authentication/logout(:token)').to(AuthenticationAction::Destroy)
  post('/authentication/notify_forgot_password(.:format)').to(AuthenticationAction::Notify)
  post('/authentication/reset_forgot_password(.:format)').to(AuthenticationAction::Update)
  #add('/auth(:app_id)(:app_secret)(:callback_url)').to(ApiAuthAction)
  
  # Rachmat's File
  #add('/registration/signup(.:format)').to(RegistrationAction::Create)

  # Admin - Auth
  get('/lord/login(.:format)').to(AdminAuthenticationActions::New).name(:admin_login_new)# Server::Application.routes.url(:admin_login_new)
  post('/lord/login(.:format)').to(AdminAuthenticationActions::Create).name(:admin_login_create)
  get('/lord/logout(.:format)').to(AdminAuthenticationActions::Delete).name(:admin_logout)
  
  # Admin - Clients
  get('/lord/clients(.:format)').to(AdminClientsAction::Index).name(:admin_clients)
  get('/lord/clients/new(.:format)').to(AdminClientsAction::New).name(:admin_clients_new)
  post('/lord/clients/new(.:format)').to(AdminClientsAction::Create).name(:admin_clients_create)
  get('/lord/clients/(:app_id)/destroy(.:format)').to(AdminClientsAction::Delete).name(:admin_clients_delete)
  get('/lord/clients/(:app_id)/edit(.:format)').to(AdminClientsAction::Edit).name(:admin_clients_edit)
  post('/lord/clients/(:app_id)/update(.:format)').to(AdminClientsAction::Update).name(:admin_clients_update)

  # Profile
  get('/profile(.:format)').to(ProfilesAction::Show)
  post('/profile/update(.:format)').to(ProfilesAction::Update)

  # Account Settings
  post('/account/update-email(.:format)').to(AccountSettingsAction::UpdateEmail)
  post('/account/update-password(.:format)').to(AccountSettingsAction::UpdatePassword)
  post('/account/update-privacy(.:format)').to(AccountSettingsAction::UpdatePrivacy)
  post('/account/update-your-stream(.:format)').to(AccountSettingsAction::UpdateYourStream)
  post('/account/update-default-post(.:format)').to(AccountSettingsAction::UpdateDefaultPost)
  post('/account/update-connection(.:format)').to(AccountSettingsAction::UpdateConnection)
  post('/account/update-media-upload(.:format)').to(AccountSettingsAction::UpdateMediaUpload)
  post('/account/update-avatar(.:format)').to(AccountSettingsAction::UpdateAvatar )

  # Jots
  #  get('/jots/index(.:format)').to(JotsAction::Index)
  #  get('/jots/index-show-more(.:format)').to(JotsAction::IndexShowMore)
  #  get('/jots/show(.:format)').to(JotsAction::Show)
  #  post('/jots(.:format)').to(JotsAction::Create)
  #  post('/jots/update(.:format)').to(JotsAction::Update)
  #  post('/jots/destroy(.:format)').to(JotsAction::Destroy)
  #
  #  # Jots - Favorites
  #  get('/jots/favorites/index(.:format)').to(JotsAction::FavoritesIndex)
  #  post('/jots/favorites/create(.:format)').to(JotsAction::FavoritesCreate)
  #  post('/jots/favorites/destroy(.:format)').to(JotsAction::FavoritesDestroy)
  #
  #  # Jots - Like
  #  post('/jots/like(.:format)').to(JotsAction::LikeCreate)
  #  post('/jots/dislike(.:format)').to(JotsAction::DislikeCreate)
  #
  #  # Jots - Comments
  #  post('/jots/comments/create(.:format)').to(JotsAction::CommentsCreate)
  #  post('/jots/comments/destroy(.:format)').to(JotsAction::CommentsDestroy)
  #
  #  # Jots - Private Messages
  #  post('/jots/messages(.:format').to(MessagesAction::CreatePrivateMessages)
  #  delete('/jots/messages/destroy(.:format').to(MessagesAction::DeletePrivateMessages)
  #  post('/jots/messages/(:id)/reply(.:format').to(MessagesAction::ReplyPrivateMessages)
  #  post('/jots/messages/index(.:format').to(MessagesAction::IndexPrivateMessages)
  #  post('/jots/messages/show/(:id)(.:format').to(MessagesAction::ShowPrivateMessages)

  # Me
  get('/me(.:format)').to(MeAction::Index)
  post('/me(.:format)').to(MeAction::Update)

  # Me - Jots
  post('/me/jots(.:format)').to(MeAction::CreateJot)
  delete('/me/jots/(:id)(.:format)').to(MeAction::DeleteJot) # Define "delete" and "put" before "get" for routes that have a same url format
  get('/me/jots/(:id)(.:format)').to(MeAction::ShowJot)
  get('/me/jots(.:format)').to(MeAction::IndexJot)

  # Me - Nest
  post('/me/nests(.:format)').to(MeAction::CreateNest)
  delete('/me/nests/(:id)(.:format)').to(MeAction::DeleteNest) # Define "delete" and "put" before "get" for routes that have a same url format
  post('/me/nests/(:id)(.:format)').to(MeAction::UpdateNest)
  get('/me/nests/(:id)(.:format)').to(MeAction::ShowNest)
  get('/me/nests(.:format)').to(MeAction::IndexNest)
  

  # Me - Tags
  post('/me/tags/subscribe(.:format)').to(MeAction::SubscribeTags)
  post('/me/tags/unsubscribe(.:format)').to(MeAction::UnsubscribeTags)
  get('/me/tags(.:format)').to(MeAction::IndexTags)

  # Me - Private Messages
  post('/me/messages(.:format)').to(MeAction::CreatePrivateMessages)
  delete('/me/messages/(:id)(.:format)').to(MeAction::DeletePrivateMessages)
  post('/me/messages/(:id)/reply(.:format)').to(MeAction::ReplyPrivateMessages)
  get('/me/messages(.:format)').to(MeAction::IndexPrivateMessages)
  get('/me/messages/(:id)(.:format)').to(MeAction::ShowPrivateMessages)

  # Me - Thumbs
  post('/me/jots/:id/thumbsup(.:format)').to(MeAction::AddJotThumbsUp)
  post('/me/jots/:id/thumbsdown(.:format)').to(MeAction::AddJotThumbsDown)
  get('/me/jots/thumbsup(.:format)').to(MeAction::IndexJotThumbsUp)
  get('/me/jots/thumbsdown(.:format)').to(MeAction::IndexJotThumbsDown)

  # Me - Favorites
  post('/me/jots/:id/favorites(.:format)').to(MeAction::AddFavoriteJot)
  post('/me/jots/favorites(.:format)').to(MeAction::IndexFavoriteJots)

  # Me - Notifications
  get('/me/notifications(.:format)').to(MeAction::IndexNotifications)

  # Omniauth - Facebook
  get('/omniauth/facebook(.:format)').to(OmniauthAction::Facebook)
  get('/omniauth/authenticate_facebook(.:format)').to(OmniauthAction::AuthenticateFacebook)

  # Omniauth - Twitter
  post('/omniauth/authenticate_twitter(.:format)').to(OmniauthAction::AuthenticateTwitter)

  # Omniauth - Google
  get('/omniauth/google(.:format)').to(OmniauthAction::Google)
  get('/oauth2callback(.:format)').to(OmniauthAction::AuthenticateGoogle)

  # Asset - https://github.com/joshbuddy/http_router
  add('/assets/').static(Server::Application.root('public')).name(:assets)
end
