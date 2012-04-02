window.MiddleSearchResultView = Backbone.View.extend({

  template: _.template($('#search-result-template').html()),

  render: function(data){
    $(this.el).html(this.template(data));
  }
})