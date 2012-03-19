window.MagicBoxPrivateView = MagicBoxView.extend({

  topNavigationTemplate: _.template($('#main-magicbox-navigation-private-template').html()),

  events: {
    "click .main-magicbox-navigation-search-link": "open_search",
    "click .main-magicbox-navigation-jot-link": "open_jot",
    "click .main-magicbox-navigation-login-link": "open_login",
    "click #user_logged": "open_profile"
  },

  initialize: function () {
    this.jotInputView = new JotInputView;
    this.searchView = new SearchView;
    this.holderView = new HolderView;
    this.loginView = new LoginView;
    this.profileView = new ProfileView;
    this.welcomeView = new WelcomeView;

    this.render();
  },

  createHolder: function(id){
    this.holderView.setElement(this.el);
    return this.holderView.renderAppendTo({idName: id, className: 'magicbox-content-tab'});
  },

  open_profile: function(){
    this.close_jot();
    this.close_search();
    this.profileView.remove();

    this.profileView.setElement(this.createHolder('main-profile'));
    this.profileView.render();

    return false
  },

  close_profile: function(){
    this.close_jot();
    this.close_search();
    this.profileView.remove();
  },

  open_search: function(){
    this.close_login();
    this.close_jot();
    this.close_profile();
    this.searchView.remove();

    $('.main-magicbox-navigation-search-link').children('.main-magicbox-navigation-link-text').removeClass('search_text_not_active');
    $('.main-magicbox-navigation-search-link').children('.main-magicbox-navigation-link-icon-1').removeClass('img_1_not_active');
    
    this.searchView.setElement(this.createHolder('main-magicbox-search'));
    this.searchView.render();
    this.open_welcome();

    return false;
  },

  close_search: function(){
    $('.main-magicbox-navigation-search-link').children('.main-magicbox-navigation-link-text').addClass('search_text_not_active');
    $('.main-magicbox-navigation-search-link').children('.main-magicbox-navigation-link-icon-1').addClass('img_1_not_active');
    this.searchView.remove();
    this.welcomeView.remove();
  },

  open_jot: function(){
    this.close_login();
    this.close_search();
    this.close_profile();
    this.jotInputView.remove();

    $('.main-magicbox-navigation-jot-link').children('.main-magicbox-navigation-link-text').addClass('jot_text_active');
    
    this.jotInputView.setElement(this.createHolder('main-magicbox-jot-input'));
    this.jotInputView.render();
    
    return false;
  },

  close_jot: function(){
    $('.main-magicbox-navigation-jot-link').children('.main-magicbox-navigation-link-text').removeClass('jot_text_active');
    this.jotInputView.remove();
  },

  open_login: function(){
    this.close_jot();
    this.close_search();
    this.loginView.remove();
    
    $('.main-magicbox-navigation-login-link').addClass('login');

    this.loginView.setElement(this.createHolder('main-magicbox-login'));
    this.loginView.render();

    return false;
  },

  close_login: function(){
    $('.main-magicbox-navigation-login-link').removeClass('login');
    this.loginView.remove();
  },

  open_welcome: function(){
    this.welcomeView.setElement(this.createHolder('main-welcome'));
    this.welcomeView.render();
  },

  close_welcome: function(){
    this.welcomeView.remove();
  }
});
