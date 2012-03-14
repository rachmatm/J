window.JotInputMoreContentView = Backbone.View.extend({
  template: _.template($('#main-magicbox-jot-input-more-content-template').html()),

  render: function(){
    $(this.el).html(this.template());
  }
});