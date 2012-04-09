window.FavoriteCollection = Backbone.Collection.extend({

  model: FavoriteModel,

  url: '/favorites',

  parse: function(response) {
    return response.content;
  }
});
