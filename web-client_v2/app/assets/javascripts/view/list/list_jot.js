window.ListJotView = Backbone.View.extend({
  
  template: _.template($('#list-jot-template').html()),

  initialize: function(){
    this.currentUserModel = new CurrentUserModel;
    this.middleView = new MiddleView;
    this.middleView.setElement('#main-middle');
    this.sidebarView = new SidebarView;
  },

  events: {
    'click .link-to-thumbsup': 'thumbsup',
    'click .link-to-thumbsdown': 'thumbsdown',
    'click .link-to-fav': 'favorite',
    'click .link-to-detail': 'detail'
  },

  data: {},

  render: function(){
    this.data = $.extend( this.model.toJSON(), {
      current_user: this.currentUserModel.data()
    } ) ;
    
    $(this.el).html(this.template( this.data ));

    $("abbr.timeago").timeago();
  },

  thumbsup: function(){
    var _this = this;
    
    $.ajax({
      url: '/jots/'+ this.data._id + '/thumbsup.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR)
      }
    });
  },

  thumbsdown: function(){
    var _this = this;

    $.ajax({
      url: '/jots/'+ this.data._id + '/thumbsdown.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR)
      }
    });
  },

  favorite: function(){
    var _this = this;
    
    $.ajax({
      url: '/jots/'+ this.data._id + '/favorite.json',
      error: function(jqXHR, textStatus, errorThrown){
        _this.error.call(_this, jqXHR, textStatus, errorThrown);
      },
      success: function(data, textStatus, jqXHR){
        _this.success.call(_this, data, textStatus, jqXHR);
      }
    });
  },

  error: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },

  success: function(data, textStatus, jqXHR){
    if(data.failed === true){
      alert(data.error);
    }
    else{
      console.log(data.content);
      this.sidebarView.sidebarFavorites.fetch();
      this.model.set(data.content);
      this.render();
    }
  },

  detail: function(){
    this.middleView.openJotDetail(this.data)
  }
});
