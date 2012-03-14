window.SearchView = Backbone.View.extend({
  
  template: _.template($('#main-magicbox-search-template').html()),

  render: function(){
    $(this.el).html(this.template());
  }
});