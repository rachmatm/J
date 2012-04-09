window.NestItemCollection = Backbone.Collection.extend({

  model: NestItemModel,

  initialize: function(nest_id){
    this.nest_id = nest_id;
  },

  url: function() {
    return '/nests/' + this.nest_id + '/nest_items';
  },

  parse: function(response) {
    return response.content;
  }
})
