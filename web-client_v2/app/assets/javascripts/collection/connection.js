window.ConnectionCollection = Backbone.Collection.extend({
  model: ConnectionModel,

  url: '/connections',

  parse: function(response) {
    return response.content;
  }
});