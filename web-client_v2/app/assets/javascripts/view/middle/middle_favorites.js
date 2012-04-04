window.MiddleFavoritesView = Backbone.View.extend({

  template: _.template($('#favorites-template').html()),

  initialize: function(){
    this.favorites = new FavoriteCollection;
    this.favorites.bind('add', this.addItem, this);
    this.favorites.bind('all', this.renderItem, this);
    this.favorites.bind('reset', this.resetItem, this);
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template());

    this.favorites.fetch();

  },

  addItem: function(data){
    this.item(data, true)
  },

  renderItem: function(){
    
  },

  resetItem: function(){
    var _this = this;

    console.log(this.favorites);
    this.favorites.each(function(data){
      _this.item(data);
    });
  },

  item: function(data, reverse){

    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#main-middle-favorites-list');
    this.listView.openFavorites(reverse);
  },

  more: function(){
    var last_data = _.last(this.model.toJSON());

    if(last_data){
      this.model.more({timestamp: last_data.updated_at});
    }
    else{
      $(this.moreEl).remove();
    }
  }
});
