//window.AppRouter = Backbone.Router.extend({
//
//  elAlert: $('#alert-message-holder'),
//
//  elTopNavLoginHolder: $('#top-navigation-login-holder'),
//
//  elTopNavLogoutHolder: $('#top-navigation-logout-holder'),
//
//  initialize: function(){
//    var _this = this;
//
//    this.magicboxView = new MagicboxView;
//
//    if(this.validateAuth()){
//      this.setLogged();
//    }
//    else{
//      this.setUnlogged();
//    }
//
//    $(window).bind('jotky_login',function(event, jotky_token){
//      _this.authLogin(jotky_token);
//    });
//  },
//
//  routes: {
//    "": "search",
//
//    "!/login": "login",
//
//    "!/jots": "jot",
//
//    "!/search": "search",
//
//    "!/signup": "signup",
//
//    "!/signout": "signout"
//  },
//
//  login: function() {
//    this.magicboxView.openLogin();
//  },
//
//  jot: function() {
//    this.magicboxView.openJot();
//  },
//
//  search: function(){
//    this.magicboxView.openSearch();
//  },
//
//  signup: function(){
//    this.magicboxView.openLogin();
//    this.magicboxView.openMiddleSignup();
//  },
//
//  authLogin: function(token){
//    var _this = this;
//
//    $.cookie("jotky_token", token, {
//      expires : 10,
//
//      path    : '/',
//
//      domain  : DOMAIN,
//
//      secure  : false
//    });
//
//    $.ajax({
//      url: '/profiles.json',
//      data: {
//        token: token
//      },
//      error: function(jqXHR, textStatus, errorThrown){
//        alert(textStatus);
//      },
//      success: function(data, textStatus, jqXHR){
//        if(data.failed === true){
//        //alert(data.error)
//        }
//        else{
//          localStorage.jotky_user_session = JSON.stringify(data.content);
//          _this.currentUser();
//          _this.setLogged();
//        }
//      }
//    })
//  },
//
//  currentUser: function(){
//    this.current_user = JSON.parse(localStorage.jotky_user_session);
//  },
//
//  afterLoginTopNavigation: function(){
//    var data = this.current_user;
//
//    this.magicboxView.openLoggedinPanel();
//
//    $('.template-username').text(data.username);
//    $('.template-avatar-small').attr({
//      src: data.avatar.thumb_small.url
//    })
//  },
//
//  linkToLogout: function(){
//    $(this.elTopNavLoginHolder).addClass('hidden');
//    $(this.elTopNavLogoutHolder).removeClass('hidden');
//  },
//
//  linkToLogin: function(){
//    $(this.elTopNavLoginHolder).removeClass('hidden');
//    $(this.elTopNavLogoutHolder).addClass('hidden');
//  },
//
//  signout: function(){
//    $.cookie("jotky_token", null);
//    localStorage.jotky_user_session = "{}";
//    this.magicboxView.closeLoggedinPanel();
//    this.linkToLogin();
//  },
//
//  setLogged: function(){
//    this.afterLoginTopNavigation();
//    this.linkToLogout();
//    //this.magicboxView.openProfile();
//
//    location.href ='#!/jots'
//  },
//
//  setUnlogged: function(){
//    this.magicboxView.closeLoggedinPanel();
//    this.linkToLogin();
//  //this.magicboxView.closeProfile();
//  },
//
//  validateAuth: function(){
//    this.currentUser();
//    this.jotky_token_cookie = $.cookie("jotky_token");
//
//    return this.jotky_token_cookie && this.current_user;
//  }
//});
//
//var appRouter = new AppRouter;
//
//Backbone.history.start();