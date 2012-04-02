window.ProfileCollection = Backbone.Collection.extend({

  model: JotModel,

  url: '/profiles',

  parse: function(response) {
    return response.content;
  }
});