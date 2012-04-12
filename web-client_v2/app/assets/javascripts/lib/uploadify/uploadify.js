$.fn.setUploadify = function(options, uploadify_script_data){

  return build(this, options, uploadify_script_data);

  function build(file, uploadifyConfig, uploadify_script_data){
    if (file.length == 0) return;

    // Create an empty object to store our custom script data
    var uploadify_script_data = uploadify_script_data || {};

    // Fetch the file control and the form
    var form = file.parents('form');
    
    if(form){
      jQuery.each(form.serializeArray(), function(i, field) {
        if (field.name == 'authenticity_token') {
          // need to preserve those plus signs
          uploadify_script_data[field.name] = encodeURI(field.value).replace(/\+/g, '%2B');
        }
        else{
          uploadify_script_data[field.name] = field.value;
        }
      });
    }

    
    
    // Fetch the session info from the meta tags, if it exists
    var session_token = jQuery('meta[name=session-token]').attr('content');

    if (typeof(session_token) != "undefined") {
      var session_param = jQuery('meta[name=session-param]').attr('content');
      uploadify_script_data[session_param] = encodeURI(session_token);
    }

    uploadify_script_data['swfUpload'] = true;

    var lastResponse = null;
 
    var defaultConfig = {
      multi: false,
      queueSizeLimit: 10,
      uploader: '/assets/uploadify.swf',
      script: form.attr('action'),
      cancelImg: '/assets/cancel.png',
      fileDataName: file.attr('name'),
      scriptData: uploadify_script_data
    }

    // Configure Uploadify
    file.uploadify(jQuery.extend(defaultConfig, uploadifyConfig));
  } 
};