window.ListUploadedClipView = Backbone.View.extend({

  template: _.template($('#list-uploaded-clip-template').html()),

  render: function(){
    this.data = this.model.toJSON();

    $(this.el).html(this.template(this.data));
  },

  events: {
    'click .link-to-delete-uploaded-clip': 'destroy'
  },

  destroy: function(){
    alert('asd')
  }
})