window.MiddleUserView = Backbone.View.extend({

  template: _.template($('#profile-detail-template').html()),

  initialize: function(){
    this.users = new UserCollection;
    this.users.bind('reset', this.setData, this);
  },

  render: function(options){
    this.users.fetch(options || {});
  },

  setData: function(){
    var _this = this;

    this.users.each(function(data){
      _this.setTemplate(data);
    });
  },

  setTemplate: function(data){
    $(this.el).html(this.template(data.toJSON()));
  }
});