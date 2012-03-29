window.ListView = Backbone.View.extend({
  
  initialize: function(){
    this.holderView = new HolderView;
  },

  createHolder: function(id, reverse){
    this.holderView.setElement(this.el);
    this.holderView.render({
      id: id,
      className: 'list-jot clearfix'
    }, reverse);

    return this.holderView.holder_el;
  },

  openJot: function(reverse){
    var data = this.model.toJSON();

    this.listJotView = new ListJotView({model: this.model});
    this.listJotView.setElement(this.createHolder('list-jot-' + data._id, reverse));
    this.listJotView.render();
  }
})