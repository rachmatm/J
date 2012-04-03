window.ListView = Backbone.View.extend({
  
  initialize: function(){
    this.holderView = new HolderView;
  },

  createHolder: function(id, reverse, table){
    this.holderView.setElement(this.el);
    this.holderView.render({
      id: id,
      className: 'list-view'
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
    
    this.listCommentView.setElement(this.createHolder('list-comment-' + data._id, reverse));
    this.listCommentView.render();
  },

  openConnection: function(reverse){
    var data = this.model.toJSON();

    this.listConnectionView = new ListConnectionView({
      model: this.model
    });

    this.listConnectionView.setElement(this.createHolder('list-connection-' + data._id, reverse, true));
    this.listConnectionView.render();
  },

  openNest: function(reverse){
    var data = this.model.toJSON();

    this.listNestView = new ListNestView({
      model: this.model
    });

    this.listNestView.setElement(this.createHolder('list-nest-' + data._id, reverse));
    this.listNestView.render();
  }
})