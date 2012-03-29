window.MagicboxSearchView = Backbone.View.extend({
  
  default_options: {
    elNav: '',
    el: ''
  },

  initialize: function(options){
    this.options = $.extend({}, this.default_options, options);
  },

  open: function(){
    $(this.options.elNav).find('.img_1').removeClass('img_1_not_active');
    $(this.options.elNav).find('.search_text').removeClass('search_text_not_active');
    $(this.options.el).removeClass('hidden');
  },

  close: function(){
    $(this.options.elNav).find('.img_1').addClass('img_1_not_active');
    $(this.options.elNav).find('.search_text').addClass('search_text_not_active');
  }
})