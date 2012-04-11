window.UserCollection = Backbone.Collection.extend({

  model: UserModel,

  url: '/users',

  parse: function(response) {
    return response.content;
  }

});