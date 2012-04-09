window.MiddleSearchResultJotView = Backbone.View.extend({

  template: _.template($('#search-result-jot-template').html()),

  render: function(data){
    $(this.el).html(this.template(data));
  }
})