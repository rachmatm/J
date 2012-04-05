window.MessageRepliesCollection = Backbone.Collection.extend({

  initialize: function(properties) {
    this.url = '/messages/' + properties.id + '/reply';
  },

  model: MessageModel,

  parse: function(response) {
    return response.content;
  }
});
