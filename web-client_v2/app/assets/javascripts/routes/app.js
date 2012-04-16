window.AppRouter = Backbone.Router.extend({

  initialize: function(){
    this.headerView = new HeaderView;
    this.sidebarView = new SidebarView;
    this.footerView = new FooterView;
    this.magicboxView = new MagicboxView;
    this.footerView = new FooterView;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
  },
  
  routes: {
    "": "search",

    "!/login": "login",

    "!/jots": "jot",

    "!/search": "search",

    "!/signup": "signup",

    "!/signout": "signout",

    "!/profile": "profile",

    "!/setting": "setting",

    "!/jots/:id": "jotDetail",
    
    "!/profile/public": "profilePublic",

    "!/nest": "nest",

    "!/forgot_password": "forgotPassword",

    "!/change_password/*token": "changePassword",

    "!/account_setting": "accountSetting",

    "!/about": "about",

    "!/favorites": "favorites",

    "!/inbox": "messages",

    "!/users/:id": "userDetail",

    "!/registrations/completion": "registrationCompletion"
  },

  render: function(){
    this.headerView.setElement('#header-holder');
    this.headerView.render();

    this.sidebarView.setElement('#sidebar-holder');
    this.sidebarView.render();

    this.footerView.setElement('#footer-holder');
    this.footerView.render();
  },

  login: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openLogin();
    this.middleView.openWelcome();
  },

  jot: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openJot();
  },

  search: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openSearch();
    this.middleView.openWelcome();
  },

  signup: function(){
    if(this.hook()){return;};
    this.render();
    this.initMagicbox();
    this.magicboxView.openLogin();
    
    this.middleView.openSignup();
  },

  signout: function(){
    this.render();
    $(window).trigger('auth:logout');
  },

  profile: function(){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();
    
    this.initMagicbox();
    this.magicboxView.openProfile();
  },

  setting: function(){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();

    this.initMagicbox();
    this.magicboxView.openSetting();
  },

  jotDetail: function(id){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();

    this.initMagicbox();
    this.magicboxView.openJotDetail(id);
  },

  profilePublic: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openSearch();
    this.middleView.closeAll();
    this.middleView.openProfile();
  },

  nest: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openSearch();
    this.middleView.closeAll();
    this.middleView.openNest();
  },

  forgotPassword: function(){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();
    this.middleView.openForgotPassword();
  },

  changePassword: function(token){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();
    this.middleView.openChangePassword(token);
  },

  accountSetting: function(id){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();
    this.middleView.openAccountSetting(id);
  },

  about: function(){
    if(this.hook()){return;};
    this.render();
    this.initMagicbox();
    this.magicboxView.openSearch();
    this.middleView.closeAll();
    this.middleView.openAbout();
  },

  favorites: function(){
    if(this.hook()){return;};
    this.render();
    this.middleView.closeAll();
    this.middleView.openFavorites();
  },

  messages: function(){
    if(this.hook()){return;};
    this.render();

    this.initMagicbox();
    this.magicboxView.openSearch();

    this.middleView.closeAll();
    this.middleView.openMessages();
  },

  userDetail: function(id){
    if(this.hook()){return;};
    this.render();
    
    this.initMagicbox();
    this.magicboxView.openSearch();

    this.middleView.closeAll();
    this.middleView.openUser(id);
  },

  registrationCompletion: function(){
    this.middleView.openLoginCompletion();
  },

  hook: function(){
    if(CURRENT_USER.auth && CURRENT_USER.token && CURRENT_USER.data && !CURRENT_USER.data.username){
      location.href = '#!/registrations/completion';
      return true;
    }
    else{
      return false;
    }
  },

  initMagicbox: function(){
    this.magicboxView.setElement('#magicbox-holder');
    this.magicboxView.render();
  }
});
