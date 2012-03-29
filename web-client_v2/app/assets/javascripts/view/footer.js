window.FooterView = Backbone.View.extend({

  template: _.template($('#footer-template').html()),
  
  intialize: {
    
  },

  default_vars: {
    
  },

  render: function(vars){
    $(this.el).html(this.template( $.extend(this.default_vars, vars) ));
  }
});