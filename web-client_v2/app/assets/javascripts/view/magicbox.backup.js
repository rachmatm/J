//window.MagicboxView = Backbone.View.extend({
//
//  template: _.template($('#magicbox-template').html()),
//
//  el: $('#main-content'),
//
//  elNavLogin: $('#magicbox-navigation-login'),
//
//  elNavSearch: $('#magicbox-navigation-search'),
//
//  elNavJot: $('#magicbox-navigation-jot'),
//
//  elSearch: $('#magicbox-search'),
//
//  elJot: $('#magicbox-jot'),
//
//  elLogin: $('#magicbox-login'),
//
//  elLoginForm: $('#login-form'),
//
//  elContent: $('#magicbox-content-tab'),
//
//  elContentTab: $('.magicbox-content-tab-item'),
//
//  elMiddleWelcome: $('#main-middle-welcome'),
//
//  elMiddleSignup: $('#main-middle-signup'),
//
//  elMiddleSignupForm: $('#signup-form'),
//
//  elMiddleContent: $('.main-middle-item'),
//
//  elLoggedinPanel: $('#magicbox-navigation-logged-in'),
//
//  elMiddleJot: $('#main-middle-jot'),
//
//  initialize: function(){
//    this.signupView = new SignupView({elMiddleSignup: this.elMiddleSignup, elMiddleSignupForm: this.elMiddleSignupForm});
//    this.loginView = new LoginView({el: this.elLogin, elForm: this.elLoginForm});
//
//    this.holderView  = new HolderView;
//
//    this.magicboxProfileView = new MagicboxProfileView;
//  },
//
//  render: function(){
//    $(this.elNavLogin).append(this.navigationTemplate)
//  },
//
//  openJot: function(){
//    $(this.elContentTab).addClass('hidden');
//
//    $(this.elNavJot).find('.jot_text').addClass('jot_text_active');
//    $(this.elJot).removeClass('hidden');
//
//    this.jotView = new JotView;
//
//    this.openMiddleJot();
//  },
//
//  closeJot: function(){
//    $(this.elNavJot).find('.jot_text').removeClass('jot_text_active');
//  },
//
//  openLogin: function(){
//    $(this.elContentTab).addClass('hidden');
//
//    $(this.elNavLogin).addClass('login');
//    $(this.elLogin).removeClass('hidden');
//
//    this.openMiddleWelcome();
//  },
//
//  closeLogin: function(){
//    $(this.elNavLogin).removeClass('login');
//  },
//
//  openSearch: function(){
//    $(this.elContentTab).addClass('hidden');
//
//    $(this.elNavSearch).find('.img_1').removeClass('img_1_not_active');
//    $(this.elNavSearch).find('.search_text').removeClass('search_text_not_active');
//    $(this.elSearch).removeClass('hidden');
//    this.openMiddleWelcome();
//  },
//
//  closeSearch: function(){
//    $(this.elNavSearch).find('.img_1').addClass('img_1_not_active');
//    $(this.elNavSearch).find('.search_text').addClass('search_text_not_active');
//  },
//
//  openMiddleSignup: function(){
//    $(this.elMiddleContent).addClass('hidden');
//
//    $(this.elMiddleSignup).removeClass('hidden');
//  },
//
//  closeMiddleSignup: function(){
//
//  },
//
//  openMiddleWelcome: function(){
//    $(this.elMiddleContent).addClass('hidden');
//
//    $(this.elMiddleWelcome).removeClass('hidden');
//  },
//
//  closeMiddleWelcome: function(){
//
//  },
//
//  openMiddleJot: function(){
//    $(this.elMiddleContent).addClass('hidden');
//    $(this.elMiddleJot).removeClass('hidden');
//  },
//
//  closeMiddleJot: function(){
//
//  },
//
//  openLoggedinPanel: function(){
//    $(this.elNavLogin).addClass('hidden');
//    $(this.elLoggedinPanel).removeClass('hidden');
//  },
//
//  closeLoggedinPanel: function(){
//    $(this.elNavLogin).removeClass('hidden');
//    $(this.elLoggedinPanel).addClass('hidden');
//  },
//
//  holderContentTab: function(id){
//    this.holderView.setElement(this.elContent);
//    this.holderView.render({id: id, className: 'middle-content magicbox-content-tab-item'})
//
//    return this.holderView.holder_el;
//  },
//
//  openProfile: function(){
//    $(this.elContentTab).addClass('hidden');
//
//    var el = this.holderContentTab('magicbox-profile');
//
//    this.magicboxProfileView.setElement(el);
//    this.magicboxProfileView.render();
//  },
//
//  closeProfile: function(){
//    this.magicboxProfileView.remove();
//  }
//});