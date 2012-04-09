window.SidebarView = Backbone.View.extend({

  template: _.template($('#sidebar-template').html()),

  initialize: function(){
    this.sidebarFavorites = new FavoriteCollection;
    this.sidebarFavorites.bind('add', this.addFavoriteItem, this);
    this.sidebarFavorites.bind('all', this.renderFavoriteItem, this);
    this.sidebarFavorites.bind('reset', this.resetFavoriteItem, this);
  },

  default_vars: {
    current_user: ''
  },

  render: function(vars){
    this.sidebarFavorites.fetch();

    $(this.el).html(this.template( $.extend(this.default_vars, vars) ));

    return this;
  },

  events: {
    'click .link-to-nest': 'nest'
  },

  nest: function(){
    location.href = '#!/nest'
  },

  addFavoriteItem: function(data){
    this.favoriteItem(data)
  },

  renderFavoriteItem: function(){
    
  },

  resetFavoriteItem: function(){
    var _this = this;

    $('#main-sidebar-favorites').html("");
    this.sidebarFavorites.each(function(data){
      _this.favoriteItem(data);
    });
  },

  favoriteItem: function(data, reverse){

    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#main-sidebar-favorites');
    this.listView.openSidebarFavorite(reverse);
  }
})
