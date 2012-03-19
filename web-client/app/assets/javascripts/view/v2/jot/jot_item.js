window.JotItem = AppView.extend({
  template: _.template($('#main-listing-jot-item-template').html()),

  // The TodoView listens for changes to its model, re-rendering.
  initialize: function() {
    var appHolderView = new AppHolderView;

    this.model.bind('change', this.render, this);
    this.model.bind('destroy', this.remove, this);
  },

  createHolder: function(){
    appHolderView.setElement()
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));
    return this
  }
});