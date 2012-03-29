window.MagicboxProfileView = Backbone.View.extend({

  template: _.template($('#main-middle-jot-item-template').html()),

  render: function(){
    $(this.el).append(this.template());
  }
})