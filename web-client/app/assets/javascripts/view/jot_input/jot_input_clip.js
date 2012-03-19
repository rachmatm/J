window.JotInputClip = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-clip-template').html()),

  initialize: function(){
    this.uploadifyView = new UploadifyView;
    this.formView = new FormView;
    this.jotInputClipUploadedList = new JotInputClipUploadedList;
  },

  field_attachment_upload_status: {
    id: '#jot-input-field-attachment-uploaded',
    name : 'jot[attachment_uploaded]'
  },

  form_id: '#main-magicbox-jot-input-clip-form',

  render: function(){
    var _this = this;
    
    $(this.el).html(this.template);

    this.formView.setElement(_this.form_id);

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
    this.jotInputClipUploadedList.setElement('#main-magicbox-jot-input-clip-uploaded-files');

    this.uploadifyView.render({
      script: '/files.json',
      onComplete: function(event, ID, fileObj, response, data){
        var response_as_json = JSON.parse(response);

        if(response_as_json.failed === false){
          _this.jotInputClipUploadedList.render({
            id: response_as_json.content[0]._id,
            file_name: response_as_json.content[0].file_name,
            file_preview_url: response_as_json.content[0].file.thumb.url,
            file_size: response_as_json.content[0].file_file_size
          });
        }
        else{
          alert("Upload failed: "+ response_as_json.failed +"")
        }
      },

      onAllComplete: function(event,data){
        $('#jot-input-field-attachment-uploaded').val(3);
      },
      onSelectOnce: function(){
        $('#jot-input-field-attachment-uploaded').val(2);
      },
      auto: true,
      scriptData: scriptData
    });
  }
});