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

    "!/jots/:id": "jotDetail",

    "!/forgot_password": "forgotPassword",

    "!/change_password/*token": "changePassword",

    "!/account_setting": "accountSetting"
  },

  render: function(parameters){
    parameters = parameters || {}
    
    this.drawMainLayout(parameters.current_user, parameters.current_user_token);
  },

  drawMainLayout: function(current_user, current_user_token){
    this.current_user = current_user;

    this.headerView.setElement('#header-holder');
    this.headerView.render({
      current_user: current_user
    });

    this.sidebarView.setElement('#sidebar-holder');
    this.sidebarView.render({
      current_user: current_user
    });

    this.footerView.setElement('#footer-holder');
    this.footerView.render();

    if(current_user.username || _.isEmpty(current_user)){
      this.magicboxView.setElement('#magicbox-holder');
      this.magicboxView.render({
        current_user: current_user
      });
    }
    else{
      $(this.magicboxView.el).children().remove();
      this.middleView.openLoginCompletion({
        current_user: current_user
      });
    }
  },

  login: function(){
    this.magicboxView.openLogin();
    this.middleView.openWelcome();
    return false;
  },

  jot: function(){
    this.magicboxView.openJot();
    return false;
  },

  search: function(){
    this.magicboxView.openSearch();
    this.middleView.openWelcome();
    
    return false;
  },

  signup: function(){
    this.middleView.openSignup();
    return false;
  },

  signout: function(){
    $(window).trigger('jotky_logout', this.token);
    return false;
  },

  profile: function(){ 
    this.middleView.closeAll();
    this.magicboxView.openProfile();
    return false;
  },

  setting: function(){
    this.middleView.closeAll();
    this.magicboxView.openSetting();
    return false;
  },

  jotDetail: function(id){
    this.middleView.closeAll();
    this.magicboxView.openJotDetail(id);
  },

  profilePublic: function(){
    this.magicboxView.openSearch();
    this.middleView.closeAll();
    this.middleView.openProfile();
  },

  nest: function(){
    this.middleView.closeAll();
    this.middleView.openNest();
  },

    forgotPassword: function(){
    this.middleView.openForgotPassword();
    return false;
  },

  changePassword: function(token){
    this.middleView.openChangePassword(token);
    return false;
  },

  accountSetting: function(id){
    this.middleView.closeAll();
    this.middleView.openAccountSetting(id);
  }
});