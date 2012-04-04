window.MessageCollection = Backbone.Collection.extend({

  model: MessageModel,

  url: '/messages',

  parse: function(response) {
    return response.content;
  }
});
