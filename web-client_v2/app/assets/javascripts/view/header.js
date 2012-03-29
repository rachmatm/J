window.HeaderView = Backbone.View.extend({

  template: _.template($('#header-template').html()),

  initialize: function(){
    
  },

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    $(this.el).html(this.template( $.extend(this.default_vars, vars) ));

    return this;
  }
});