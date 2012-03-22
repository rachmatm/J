window.JotItem = AppView.extend({
  template: _.template($('#main-listing-jot-item-template').html()),

  template_variables: {
    title: '',
    detail: ''
  },

  events:{
    'click .link-to-thumbsup': 'thumbsup',
    'click .link-to-thumbsdown': 'thumbsdown',
    'click .link-to-delete': 'destroy',
    'click .link-to-fav': 'favorite'
  },

  thumbsup: function(){
    var data = this.model.toJSON();
    var _this = this;
  
    $.ajax({
      url: '/jots/'+ data._id +'/thumbsup.json',
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          $(_this.el).find('.thumbsup-counter').text(data.total_thumbsup);
          $(_this.el).find('.thumbsdown-counter').text(data.total_thumbsdown);
        }
      },

      error: function(jqXHR, textStatus, errorThrown){
        alert("Thumbsup action failed: " + textStatus)
      }
    });

    return false;
  },

  thumbsdown: function(){
    var data = this.model.toJSON();
    var _this = this;

    $.ajax({
      url: '/jots/'+ data._id +'/thumbsdown.json',
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          $(_this.el).find('.thumbsup-counter').text(data.total_thumbsup);
          $(_this.el).find('.thumbsdown-counter').text(data.total_thumbsdown);
        }
      },

      error: function(jqXHR, textStatus, errorThrown){
        alert("Thumbsup action failed: " + textStatus)
      }
    });

    return false;
  },

  destroy: function(){
    var data = this.model.toJSON();
    var _this = this;

    $.ajax({
      url: '/jots/'+ data._id +'/destroy.json',
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          _this.remove();
        }
      },

      error: function(jqXHR, textStatus, errorThrown){
        alert("Thumbsup action failed: " + textStatus)
      }
    });

    return false;
  },

  favorite: function(){
    var data = this.model.toJSON();
    var _this = this;
    
    $.ajax({
      url: '/jots/'+ data._id +'/fav.json',
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          if(data.faved){
            $(_this.el).find('.link-to-fav').text('faved');
          }
          else{
            $(_this.el).find('.link-to-fav').text('fav');
          }
          
        }
      },

      error: function(jqXHR, textStatus, errorThrown){
        alert("Thumbsup action failed: " + textStatus)
      }
    });
  }
});