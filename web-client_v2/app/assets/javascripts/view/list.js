window.ListView = Backbone.View.extend({
  
  initialize: function(){
    this.holderView = new HolderView;
  },

  createHolder: function(id, reverse, table, className){
    this.holderView.setElement(this.el);
    this.holderView.render({
      id: id,
      className: className || 'list-view'
    }, reverse, table);

    return this.holderView.holder_el;
  },

  openJot: function(reverse){
    var data = this.model.toJSON();

    this.listJotView = new ListJotView({
      model: this.model
    });
    this.listJotView.setElement(this.createHolder('list-jot-' + data._id, reverse));
    this.listJotView.render();
  },

  openComment: function(reverse){
    var data = this.model.toJSON();

    this.listCommentView = new ListCommentView({
      model: this.model
    });
    
    this.listCommentView.setElement(this.createHolder('list-comment-' + data._id, reverse, 'li'));
    this.listCommentView.render();
  },

  openConnection: function(reverse){
    var data = this.model.toJSON();

    this.listConnectionView = new ListConnectionView({
      model: this.model
    });

    this.listConnectionView.setElement(this.createHolder('list-connection-' + data._id, reverse, 'tr'));
    this.listConnectionView.render();
  },

  openNest: function(reverse){
    var data = this.model.toJSON();

    this.listNestView = new ListNestView({
      model: this.model
    });

    this.listNestView.setElement(this.createHolder('list-nest-' + data._id, reverse));
    this.listNestView.render();
  },


  openListTag: function(reverse){
    var data = this.model;

    this.listTagView= new ListTagView({
      model: this.model
    });

    this.listTagView.setElement(this.createHolder('list-tag-' + data.tag, reverse, 'li', 'link-to-add-to-nest'));
    this.listTagView.render();
  },
  
  openFavorites: function(reverse){
    var data = this.model.toJSON();

    this.listFavoritesView = new ListFavoritesView({
      model: this.model
    });

    this.listFavoritesView.setElement(this.createHolder('list-favorite' + data._id, reverse));
    this.listFavoritesView.render();
  },

  openSidebarFavorite: function(reverse){
    var data = this.model.toJSON();

    this.listSidebarFavoriteView = new ListSidebarFavoriteView({
      model: this.model
    });

    this.listSidebarFavoriteView.setElement(this.createHolder('list-sidebar-favorite' + data._id, reverse));
    this.listSidebarFavoriteView.render();
  },

  openMessages: function(reverse){
    var data = this.model.toJSON();

    this.listMessagesView = new ListMessagesView({
      model: this.model
    });

    this.listMessagesView.setElement(this.createHolder('list-messages' + data._id, reverse));
    this.listMessagesView.render();
  },

  openMessageReplies: function(reverse){
    var data = this.model.toJSON();

    this.listMessageRepliesView = new ListMessageRepliesView({
      model: this.model
    });

    this.listMessageRepliesView.setElement(this.createHolder('list-message-replies' + data._id, reverse));
    this.listMessageRepliesView.render();
  },

  openUploadedClip: function(reverse){
    var data = this.model.toJSON();

    this.listUploadedClipView = new ListUploadedClipView({
      model: this.model
    });

    this.listUploadedClipView.setElement(this.createHolder('list-uploaded-clip' + data._id, reverse));
    this.listUploadedClipView.render();    
  },

  openJotTag: function(reverse){
    var data = this.model;

    this.listJotTagView = new ListJotTagView({
      model: this.model
    });

    this.listJotTagView.setElement(this.createHolder('list-jot-tag' + data._id, reverse));
    this.listJotTagView.render();
  }
});
