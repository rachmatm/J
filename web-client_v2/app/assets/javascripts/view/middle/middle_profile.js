window.MiddleProfileView = Backbone.View.extend({

  template: _.template($('#profile-detail-template').html()),

  initialize: function(){
    this.profiles = new ProfileCollection;
    this.profiles.bind('reset', this.setData, this);
  },

  render: function(){
    this.profiles.fetch();
  },

  setData: function(){
    var _this = this;
    
    this.profiles.each(function(data){
      _this.setTemplate(data);
    });
  },

  setTemplate: function(data){
    $(this.el).html(this.template(data.toJSON()));
  }
});