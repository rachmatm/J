window.MessageRepliesModel = Backbone.Model.extend({

  initialize: function(props) { 
      this.url = props.url;
  },

  idAttribute: "_id"

});
