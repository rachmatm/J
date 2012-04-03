window.ListSidebarFavoriteView = Backbone.View.extend({
  
  template: _.template($('#list-sidebar-favorite-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.listView = new ListView;
    this.listView.setElement('#main-sidebar-favorites');
  },

  events: {
  },

  data: {},

  render: function(){
    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    });

    $(this.el).html(this.template( this.data ));
  },

  error: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },

  success: function(data, textStatus, jqXHR){
    if(data.failed === true){
      alert(data.error);
    }
    else{
      this.model.set(data.content);
      this.render();
    }
  },

  detail: function(){
    this.middleView.openJotDetail(this.data)
  }
});
