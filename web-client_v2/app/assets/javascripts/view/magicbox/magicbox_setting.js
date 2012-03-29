window.MagicboxSettingView = Backbone.View.extend({

  default_options: {
    elNav: '',
    el: ''
  },

  initialize: function(options){
    this.options = $.extend({}, this.default_options, options);
  },

  open: function(){
    $(this.options.el).removeClass('hidden');
  },

  close: function(){

  }
})