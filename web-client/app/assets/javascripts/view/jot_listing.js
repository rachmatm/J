window.JotListing = Backbone.View.extend({

  template: _.template($('#main-listing-jot-template').html()),

  initialize: function(){
    this.holderView =  new HolderView;
    this.jotItemView = new JotItemView;
  },

  createHolder: function(id){
    this.holderView.setElement('#main-listing-jot-item-holder');

    return this.holderView.renderAppendTo({
      idName: id,
      className: 'search_result_container main-listing-jot-item'
    });
  },

  render: function(){
    $(this.el).html(this.template);
  },
  
  open_item: function(jot){
    this.create_item(jot);
  },

  create_item: function(item){
    this.jotItemView.setElement( this.createHolder('main-listing-jot-item-'+ item._id) );
    
    this.jotItemView.render({
      jot_user_username: item.user.username,
      jot_user_user_thumbs_down_ids: item.user_thumbs_down_ids,
      jot_user_user_thumbs_up_ids: item.user_thumbs_up_ids,
      jot_title: item.title,
      jot_created_at: item.created_at,
      jot_detail: item.detail,
      jot_tags: item.tags
    });
  }
});