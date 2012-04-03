window.FavoriteCollection = Backbone.Collection.extend({

  model: JotModel,

  url: '/favorites',

  parse: function(response) {
    return response.content;
  }
});
