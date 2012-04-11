window.CommentCollection = Backbone.Collection.extend({

  model: CommentModel,

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
  },

  more: function(parameters, limit){
    var limit = limit || 5;

    this.fetch({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
      },
      data:{
        comment:{
          timestamp: parameters.timestamp,
          per_page: limit
        }
      }
    });
  },

  addWithQuery: function(attrs, query){
    this.query = query;
    this.add(attrs)
  }
});