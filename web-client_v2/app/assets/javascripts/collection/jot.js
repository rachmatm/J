window.JotCollection = Backbone.Collection.extend({

  model: JotModel,

  url: '/jots',

  parse: function(response) {
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
        jot:{
          timestamp: parameters.timestamp,
          per_page: limit
        }
      }
    });
  }
});