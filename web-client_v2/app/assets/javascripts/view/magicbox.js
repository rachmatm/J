window.MagicboxView = Backbone.View.extend({

  template: _.template($('#magicbox-template').html()),
  
  userBarTemplate: _.template($('#user-bar-template').html()),

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    var _vars = $.extend({}, this.default_vars, vars);

    $(this.el).html(this.template( _vars ));

    $('#magicbox-navigation-logged-in-user-panel').html(this.userBarTemplate( _vars ));

    this.elTabItem = $('.magicbox-content-tab-item');

    this.magicboxLoginView = new MagicboxLoginView({
      elNav: $('#magicbox-navigation-login'),
      el: $('#magicbox-login')
    });

    this.magicboxSearchView = new MagicboxSearchView;

    this.magicboxJotView = new MagicboxJotView({
      el: $('#magicbox-jot')
    });

    this.magicboxProfileView = new MagicboxProfileView;

    this.magicboxSettingView = new MagicboxSettingView;
  },

  closeAllTab: function(){
    this.elTabItem.addClass('hidden');
    this.magicboxLoginView.close();
    this.magicboxSearchView.close();
  },

  openLogin: function(){
    this.closeAllTab();
    this.magicboxLoginView.open();
  },


  openSearch: function(){
    this.closeAllTab();
    this.magicboxSearchView.setElement('#magicbox-search');
    this.magicboxSearchView.open();
  },

  openJot: function(){
    this.closeAllTab();
    this.magicboxJotView.open();
  },

  openProfile: function(){
    this.closeAllTab();
    this.magicboxProfileView.setElement('#magicbox-profile');
    this.magicboxProfileView.render();
  },

  openSetting: function(){
    this.closeAllTab();
    this.magicboxSettingView.setElement('#magicbox-setting')
    this.magicboxSettingView.render();
  }
});