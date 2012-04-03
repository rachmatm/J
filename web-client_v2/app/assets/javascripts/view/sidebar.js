window.SidebarView = Backbone.View.extend({

  template: _.template($('#sidebar-template').html()),

  initialize: function(){
    
  },

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    $(this.el).html(this.template( $.extend(this.default_vars, vars) ));

    return this;
  },

  events: {
    'click .link-to-nest': 'nest'
  },

  nest: function(){
    location.href = '#!/nest'
  }
})
