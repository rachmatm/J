window.JotInputClip = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-clip-template').html()),

  render: function(){
    $(this.el).html(this.template);
  }
});