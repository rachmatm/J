window.JotView = AppView.extend({

  template: _.template($('#main-listing-jot-item-template').html()),

  initialize: function() {
    //this.input = this.$("#new-todo");
    this.jots = new JotCollection;
    
    this.appHolderView = new AppHolderView;
    this.appHolderView.setElement('#main-content-middle-jot-list');
    
    this.jotItem = new JotItem;

    //this.jots.bind('add', this.addOne, this);
    this.jots.bind('reset', this.render, this);
    this.jots.bind('all', this.render_all_item, this);
    
    this.jots.fetch({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
      }
    });
  },

  render: function(){
    
  },

  render_all_item: function(){
    var _this = this;
    
    this.jots.each(function(data){
      var jot = data.toJSON();
      var el = _this.appHolderView.render({idName: 'main-content-middle-jot-list-item-'+ jot._id, className: 'main-content-middle-jot-list-item'});

      _this.jotItem.setElement(el);
      _this.jotItem.render(jot);
    })
  }
});