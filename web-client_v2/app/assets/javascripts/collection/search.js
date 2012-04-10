window.SearchCollection = Backbone.Collection.extend({
  model: JotModel,

  url: '/searches',

  type: 'normal',

  parse: function(response) {
    return response.content;
  },

  fetch_by_type: function(type, data){
    this.type = type || this.type;

    var _this = this;


    this.fetch({
      data: $.extend({type: _this.type}, data),
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
      }
    });

  }
})

