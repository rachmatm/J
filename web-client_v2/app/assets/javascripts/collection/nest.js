window.NestCollection = Backbone.Collection.extend({

  model: NestModel,

  url: '/nests',

  parse: function(response) {
    return response.content;
  }

});