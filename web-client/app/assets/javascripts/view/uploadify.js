window.UploadifyView = Backbone.View.extend({

  default_parameters: {
    multi: true,
    uploader: '/assets/uploadify.swf',
    cancelImg: '/assets/cancel.png',
    auto: false,
    script: '#'
  },

  render: function(parameters){
    $(this.el).uploadify($.extend({}, this.default_parameters, parameters));
  }

});

//onComplete: function(event, ID, fileObj, response, data){
//},
//onAllComplete: function(event,data){
//},