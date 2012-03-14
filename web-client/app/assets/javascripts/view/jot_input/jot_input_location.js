window.JotInputLocation = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-location-template').html()),

  render: function(){
    $(this.el).html(this.template);
  }
});