HttpRouter.new do
  # Asset
  add('/assets/').static(Server::Application.root('public')).name(:assets)

  # Registration > Create
  post('/registration(.:format)').to(RegistrationAction::Create)

  # Authentication > Create
  post('/authentications(.:format)').to(AuthenticationAction::Create)

  # Authentication > Create Facebook
  post('/authentications/facebook(.:format)').to(AuthenticationAction::Facebook::Create)

  # Authentication > Create Twitter
  post('/authentications/twitter(.:format)').to(AuthenticationAction::Twitter::Create)

  # User > Index
  # get('/users(.:format)').to(UserAction::Index)

  # User > Show
  # get('/users/(:id)(.:format)').to(UserAction::Show)

  # Me > Index
  get('/me(.:format)').to(MeAction::Show)

  # Me > Create Jot
  post('/me/jots(.:format)').to(MeAction::Jot::Create)

  # Me > Delete Jot
  # delete('/me/jots/(:id).(.:format)').to(MeAction::Jot::Delete)

  # Me > Show Jot
  # get('/me/jots/(:jot_id)(.:format)').to(MeAction::Jot::Show)

  # Me > Index Jot
  get('/me/jots(.:format)').to(MeAction::Jot::Index)

  # Me > Create Nest
  # get('/me/nests.json').to(MeAction::Nest::Create)

  # Me > Update Nest
  # put('/me/nests/(:nest_id)(.:format)').to(MeAction::Nest::Update)

  # Me > Delete Nest
  # delete('me/nests/4f423ca38480270de0000001.json').to(MeAction::Nest::Delete)

  # Me > Show Nest
  # get('/me/nests/(:nest_id)(.:format)').to(MeAction::Nest::Show)

  # Me > Index Nest
  # get('/me/nests.json').to(MeAction::Nest::Index)

  # Me > Subscribe Tags
  # post('/me/tags/subscribe(.:format)').to(MeAction::Tag::Subscribe)

  # Me > Unsubscribe Tags
  # post('/me/tags/unsubscribe(.:format)').to(MeAction::Tag::Unsubscribe)
 
  # Me > Index Tags
  # get('/me/tags(.:format)').to(MeAction::Tag::Index)

  # Me > Create Messages
  # post('/me/messages(.:format)').to(MeAction::Message::Create)

  # Me > Delete Messages
  # delete('/me/messages/(:message_id)(.:format)').to(MeAction::Message::Delete)

  # Me > Index Messages
  # get('/me/messages(.:format)').to(MeAction::Message::Index)

  # Me > Show Messages
  # get('/me/messages/(:message_id)(.:format)').to(MeAction::Message::Show)

  # Me > Messages > Create Reply
  # post('/me/messages/(:message_id)/reply(.:format)').to(MeAction::Message::Reply::Create)

  # Me > Jot > Create Thumbsup
  post('/me/jots/(:jot_id)/thumbsup(.:format)').to(MeAction::Jot::Thumbsup::Create)

  # Me > Jot > Create Thumbsdown
  post('/me/jots/(:jot_id)/thumbsdown(.:format)').to(MeAction::Jot::Thumbsdown::Create)

  # Me > Jot > Create Rejot
  post('/me/jots/(:jot_id)/rejot(.:format)').to(MeAction::Jot::Rejot::Create)

  # Me > Jot > Index Thumbsup
  # get('/me/jots/thumbsup(.:format)').to(MeAction::Jot::Thumbsup::Index)

  # Me > Jot > Index Thumbsdown
  # get('/me/jots/thumbsdown(.:format)').to(MeAction::Thumbsdown::Index)
  
  # Me > Jot > Create Favorite
  post('/me/jots/(:jot_id)/favorites(.:format)').to(MeAction::Jot::Favorite::Create)

  # Me > Jot > Index Favorite
  # get('/me/jots/favorites(.:format)').to(MeAction::Jot::Favorite::Index)

  # Me > Index Notification
  # get('/me/notifications(.:format)').to(MeAction::Notification::Index)

  # Tag > Index
  # get('/tags(.:format)').to(MeAction::Tag::Index)


  # Admin > Auth > New
  get('/lord/login(.:format)').to(AdminAction::Auth::New).name(:admin_auth_new)

  # Admin > Auth > Create
  post('/lord/login(.:format)').to(AdminAction::Auth::Create).name(:admin_auth_create)

  # Admin > Auth > Destroy
  get('/lord/logout(.:format)').to(AdminAction::Auth::Destroy).name(:admin_auth_destroy)
  
  # Admin > Clients > Index
  get('/lord/clients(.:format)').to(AdminAction::Clients::Index).name(:admin_clients_index)
  
  # Admin > Clients > New
  get('/lord/clients/new(.:format)').to(AdminAction::Clients::New).name(:admin_clients_new)

  # Admin > Clients > Create
  post('/lord/clients/new(.:format)').to(AdminAction::Clients::Create).name(:admin_clients_create)

  # Admin > Clients > Destroy
  get('/lord/clients/(:client_id)/destroy(.:format)').to(AdminAction::Clients::Destroy).name(:admin_clients_destroy)

  # Admin > Clients > Edit
  get('/lord/clients/(:client_id)/edit(.:format)').to(AdminAction::Clients::Edit).name(:admin_clients_edit)

  # Admin > Clients > Update
  post('/lord/clients/(:client_id)/update(.:format)').to(AdminAction::Clients::Update).name(:admin_clients_update)

  
  add('/*glob').to(HttpResponseAction::Error404)
end