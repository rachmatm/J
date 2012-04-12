window.MiddleProfileView = Backbone.View.extend({

  template: _.template($('#profile-detail-template').html()),
  
  templateUploadBox: _.template($('#prompt-form-template').html()),

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
  },

  events: {
    'click .link-to-edit-avatar': 'editAvatar'
  },

  editAvatar: function(){
    var template = $(this.templateUploadBox());


    $.colorbox({html: template});
  }
});