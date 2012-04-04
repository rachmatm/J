window.MessageRepliesCollection = Backbone.Collection.extend({

  parse: function(response) {
    return response.content;
  }
});
