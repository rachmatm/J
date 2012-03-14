window.WelcomeView = Backbone.View.extend({

  template: _.template($('#main-welcome-template').html()),

  render: function(){
    $(this.el).append(this.template);
  }
});