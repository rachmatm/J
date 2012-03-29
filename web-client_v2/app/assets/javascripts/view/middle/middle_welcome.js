window.MiddleWelcomeView = Backbone.View.extend({

  template: _.template($('#welcome-template').html()),

  render: function(){
    $(this.el).html(this.template());
  }
})