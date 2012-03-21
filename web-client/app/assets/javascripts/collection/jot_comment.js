window.JotCommentCollection = Backbone.Collection.extend({

  model: JotCommentModel,

  query: {},

  initialize: function(jot_id){
    this.jot_id = jot_id;
  },

  url: function() {
    return '/jots/' + this.jot_id + '/comments';
  },

  parse: function(response) {
    this.query = response.query;
    return response.content;
  }
})