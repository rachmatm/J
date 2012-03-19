window.MagicBoxView = Backbone.View.extend({

  el: $('#main-content'),

  topNavigationTemplate: _.template($('#main-magicbox-navigation-template').html()),

  jotInputMoreContentTemplate : _.template($('#main-magicbox-jot-input-more-content-template').html()),

  jotInputLocationTemplate : _.template($('#main-magicbox-jot-input-location-template').html()),

  jotInputTagTemplate: _.template($('#main-magicbox-jot-input-tag-template').html()),

  holderTemplate: _.template($('#holder-template').html()),

  events: {
    "click .main-magicbox-navigation-search-link": "open_search",
    "click .main-magicbox-navigation-jot-link": "open_jot",
    "click .main-magicbox-navigation-login-link": "open_login"
    
  },

  initialize: function(){
    this.welcomeView = new WelcomeView;
    this.jotInputView = new JotInputView;
    this.searchView = new SearchView;
    this.loginView = new LoginView;
    this.holderView = new HolderView;
    this.aboutView = new AboutView;
    //this.render();
  },

  render: function(){
    $(this.el).append(this.topNavigationTemplate());

    this.open_search();
  },

  createHolder: function(id){
    this.holderView.setElement(this.el);
    return this.holderView.renderAppendTo({idName: id, className: 'magicbox-content-tab'});
  },

  open_search: function(){
    this.close_login();
    this.close_jot();
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
  },
   open_about: function(){
    this.close_welcome();  
    this.aboutView.remove();
    this.aboutView.setElement(this.createHolder('main-about'));
    this.aboutView.render();
       
    },
    close_about: function(){
        this.close_welcome();
        this.close_login();
        this.close_logout();
        this.close_search();
    }
});

//$('#signUp').bind('click', function(){
//  //jot
//  $('.jot-tab-content').hide();
//  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
//  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
//  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
//  $('#r-jot-result').hide();
//  $('#r-jot-result-detail').hide();
//
//  //search
//  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
//  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
//  $('.jot-search-content').hide();
//  $('#r-people-search-result').hide();
//
//  //login
//  $('.login_content').show();
//  $('#signUp').addClass('login');
//
//  $('#r-signup-content').hide();
//});


//$('#r-search-tab').bind('click', function(){
//  //jot
//  $('.jot-tab-content').hide();
//  $('.jot_mode_hide').removeClass('show_more show_add show_upload show_tags').children().hide();
//  $('.jot_buttons_path').find('a').removeClass('jot_click jot_click_active jot_buttons_active');
//  $('#r-jot-tab').find('.jot_text').removeClass('jot_text_active');
//  $('#r-jot-result').hide();
//  $('#r-jot-result-detail').hide();
//
//  //login
//  $('#signUp').removeClass('login');
//  $('.login_content').hide();
//
//  //search
//  $('#r-search-tab').find('.search_text').removeClass('search_text_not_active');
//  $('#r-search-tab').find('.img_1').removeClass('img_1_not_active');
//  $('.jot-search-content').show();
//  $('.welcome_content').show();
//  $('#r-people-search-result').hide();
//
//  $('#r-signup-content').hide();
//
//  //notifikasi
//  $('#r-notif-mode-path').hide();
//  $('#r-notification-tab').removeClass('r-notification-tab-active');
//
//  //profile
//  $('#r-profile-content').hide();
//});


//$('#r-jot-tab').bind('click', function(){
//  //jot
//  $(this).find('.jot_text').addClass('jot_text_active');
//  $('.jot-tab-content').show();
//  $('#r-jot-result').show();
//  $('#r-jot-result-detail').hide();
//
//  //search
//  $('#r-search-tab').find('.search_text').addClass('search_text_not_active');
//  $('#r-search-tab').find('.img_1').addClass('img_1_not_active');
//  $('.jot-search-content').hide();
//  $('.welcome_content').hide();
//  $('#r-people-search-result').hide();
//
//  //login
//  $('#signUp').removeClass('login');
//  $('.login_content').hide();
//
//  $('#r-signup-content').hide();
//
//  $('.search_tab').hide();
//  $('.searchResult_content_logged').hide();
//
//  //inbox
//  $('.inbox_message').hide();
//
//
//  //notifikasi
//  $('#r-notif-mode-path').hide();
//  $('#r-notification-tab').removeClass('r-notification-tab-active');
//
//  //profile
//  $('#r-profile-content').hide();
//});
