window.MiddleJotDetailView = Backbone.View.extend({

  template: _.template($('#jot-detail-template').html()),

  render: function(data){
    $(this.el).html(this.template(data));
  }
})