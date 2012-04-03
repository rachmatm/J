window.SidebarView = Backbone.View.extend({

  template: _.template($('#sidebar-template').html()),

  initialize: function(){
    
  },

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    $(this.el).html(this.template( $.extend(this.default_vars, vars) ));

    $('.fav_hover').hide();

    $('.portlet_favValue_logged').mouseover(function(){
      $(this).addClass('onhover');
    }).mouseout(function(){
      $(this).removeClass('onhover');
    });

    return this;
  }
})
