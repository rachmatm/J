window.JotCollection = Backbone.Collection.extend({

  model: JotModel,

  url: '/jots',

  parse: function(response) {
    return response.content;
  }
});

