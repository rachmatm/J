window.JotInputTag = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-tag-template').html()),

  render: function(){
    $(this.el).html(this.template());
  }

});