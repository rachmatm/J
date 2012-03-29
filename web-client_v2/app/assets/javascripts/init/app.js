window.appRouter = new AppRouter;

window.CurrentUser = CurrentUserModel.extend({

  after_login: function(data, token){
    appRouter.render({
      current_user: currentUser.data(),
      current_user_token: currentUser.token()
    });

    if(data.username){location.href = '#!/jots';}
  },

  after_logout: function(data, token){
    appRouter.render({
      current_user: currentUser.data(),
      current_user_token: currentUser.token()
    });
    location.href = '#!/jots';
  }
});

window.currentUser = new CurrentUser;
currentUser.setAuth();

appRouter.render({
  current_user: currentUser.data(),
  current_user_token: currentUser.token()
});

Backbone.history.start();

if(currentUser.token() && _.isEmpty(currentUser.data())){
  currentUser.setProfileAndLogin(currentUser.token());
}