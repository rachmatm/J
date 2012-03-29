window.MagicboxView = Backbone.View.extend({

  template: _.template($('#magicbox-template').html()),

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    $(this.el).html(this.template( $.extend({}, this.default_vars, vars) ));

    this.elTabItem = $('.magicbox-content-tab-item');

    this.magicboxLoginView = new MagicboxLoginView({
      elNav: $('#magicbox-navigation-login'),
      el: $('#magicbox-login')
    });

    this.magicboxSearchView = new MagicboxSearchView({
      el: $('#magicbox-search'),
      elNav: $('#magicbox-navigation-search')
    });

    this.magicboxJotView = new MagicboxJotView({
      el: $('#magicbox-jot')
    });

    this.magicboxProfileView = new MagicboxProfileView({
      el: $('#magicbox-profile')
    });

    this.magicboxSettingView = new MagicboxSettingView({
      el: $('#magicbox-setting')
    })
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
    this.magicboxSearchView.open();
  },

  openJot: function(){
    this.closeAllTab();
    this.magicboxJotView.open();
  },

  openProfile: function(){
    this.closeAllTab();
    this.magicboxProfileView.open();
  },

  openSetting: function(){
    this.closeAllTab();
    this.magicboxSettingView.open();
  }
});