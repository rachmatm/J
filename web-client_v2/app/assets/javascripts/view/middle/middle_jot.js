window.MiddleJotView = Backbone.View.extend({

  template: _.template($('#jot-template').html()),

  render: function(){
    var _this = this;

    $(this.el).html(this.template());

    this.moreEl = $('.show-more-list');

    $(this.moreEl).bind('click', function(){
      _this.more();
      return false;
    });
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
})