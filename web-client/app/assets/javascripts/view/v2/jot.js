window.JotView = AppView.extend({

  template: _.template($('#main-listing-jot-item-template').html()),

  elList: '#main-content-middle-jot-list',

  model: JotModel,

  initialize: function() {
    //this.input = this.$("#new-todo");
    
    this.model.bind('add', this.addOne, this);
    this.model.bind('reset', this.addAll, this);
    this.model.bind('all', this.render, this);
    
    this.model.fetch();
  }, 

  render: function(){
    this.model.each(this.addOne)
  },

  // Add a single todo item to the list by creating a view for it, and
  // appending its element to the `<ul>`.
  addOne: function(jot) {
    $(this.elList).append(this.template(this.model.toJSON()));
  }, 

  addAll: function(){
    this.model.each(this.addOne);
  }
});