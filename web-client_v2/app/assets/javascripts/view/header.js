window.HeaderView = Backbone.View.extend({

  template: _.template($('#header-template').html()),

  render: function(){
    $(this.el).html(this.template(CURRENT_USER));
    return this;
  }
});