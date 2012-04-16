window.MagicboxView = Backbone.View.extend({

  template: _.template($('#magicbox-template').html()),

  render: function(){
    $(this.el).html(this.template( CURRENT_USER ));

    this.elTabItem = $('.magicbox-content-tab-item');

    this.magicboxLoginView = new MagicboxLoginView;

    this.magicboxSearchView = new MagicboxSearchView;

    this.magicboxJotView = new MagicboxJotView;
    this.magicboxJotView.setElement('#magicbox-jot');

    this.magicboxProfileView = new MagicboxProfileView;

    this.magicboxSettingView = new MagicboxSettingView;
  },

  closeAllTab: function(){
    this.elTabItem.addClass('hidden');
    this.magicboxLoginView.close();
    this.magicboxSearchView.close();
	this.magicboxJotView.close();
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
