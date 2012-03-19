window.JotInputClipUploadedList = Backbone.View.extend({
  
  template: _.template($('#main-magicbox-jot-input-clip-uploaded-list-template').html()),

  template_variabels:{
    id: '-no-id',
    file_name: '-no-file-name',
    file_preview_url: '',
    file_size: ''
  },

  render: function(variabels){
    
    var _template_variabels = $.extend({}, this.template_variabels, variabels);
    $(this.el).prepend(this.template(_template_variabels));
  }
});