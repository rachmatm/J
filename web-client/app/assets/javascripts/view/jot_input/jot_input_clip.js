window.JotInputClip = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-clip-template').html()),

  initialize: function(){
    this.uploadifyView = new UploadifyView;
    this.formView = new FormView;
  },

  field_attachment_upload_status: {
    id: '#jot-input-field-attachment-uploaded',
    name : 'jot[attachment_uploaded]'
  },

  render: function(){
    var _this = this;
    
    $(this.el).html(this.template);

    this.formView.setElement('#main-magicbox-jot-input-clip-form');

    this.formView.render({
      rules: {
        'jot[attachment_uploaded]' :{
          range: [1,3]
        }
      }
    });

    var scriptData = [];

    $.each($(this.formView.el).serializeArray(), function(i, field) {
      scriptData[field.name] = encodeURI(encodeURIComponent(field.value));
    })

    this.uploadifyView.setElement('#jot-input-field-attachment');

    this.uploadifyView.render({
      script: '/files.json',
      onComplete: function(event, ID, fileObj, response, data){
        $(_this.form_id).append('<input type="hidden" name="attachments[]" value="' + response.content.first.id +'">');
      },

      onAllComplete: function(event,data){
        $('#jot-input-field-attachment-uploaded').val(1);
      },
      auto: true,
      scriptData: scriptData
    });
  }
});