window.MagicboxSignupView = Backbone.View.extend({

  template: _.template($('#signup-template').html()),

  open: function(vars){
    $(this.el).html(this.template());
  },

  close: function(){
  }
})