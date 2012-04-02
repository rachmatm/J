window.ListConnectionView = Backbone.View.extend({

  template: _.template($('#list-connection-template').html()),

  render: function(){
    this.data = this.model.toJSON();

    $(this.el).html(this.template( this.data ));
  },

  events: {
    'click .link-to-delete-conn': 'deleteConn'
  },

  deleteConn: function(){
    var _this = this;
    
    $.ajax({
      url: '/connections/'+ this.data._id + '/destroy',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          _this.remove();
        }
      }
    });
  },

  error: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  }
})
