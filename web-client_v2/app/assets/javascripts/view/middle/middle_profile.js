window.MiddleProfileView = Backbone.View.extend({

  template: _.template($('#profile-detail-template').html()),
  
  templateUploadBox: _.template($('#prompt-form-avatar-template').html()),

  initialize: function(){
    this.profiles = new ProfileCollection;
    this.profiles.bind('reset', this.setData, this);
    this.profiles.bind('change', this.setTemplate, this);
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

  showAllField: function(){
    $('.pp_nickname').removeClass('hidden');
    $('.pp_realname').removeClass('hidden');
    $('.pp_header_middle p').removeClass('hidden');
    $('.pp_header_middle a').removeClass('hidden');
  },

  hideAllField: function(){
    $('.pp_nickname').addClass('hidden');
    $('.pp_realname').addClass('hidden');
    $('.pp_header_middle p').addClass('hidden');
    $('.pp_header_middle a').addClass('hidden');
  },

  setTemplate: function(data){
    var _this = this;

    $(this.el).html(this.template(data.toJSON()));
  },

  events: {
    'click .link-to-edit-avatar': 'editAvatar'
  },

  editAvatar: function(){
    var template = $(this.templateUploadBox());

    template.find('input[type=file]').setUploadify();

    $.colorbox({
      html: template,
      onOpen: function(){
      }
    });

  //    $('.pp_send_message').toggle(function(){
  //      $('.show-hide-edit-panel-input').removeClass('hidden');
  //      _this.hideAllField();
  //    }, function(){
  //      $('.show-hide-edit-panel-input').addClass('hidden');
  //      _this.showAllField();
  //    });
  //
  //    $('#profile-form-username').validate({
  //      rules: {
  //        'profile[username]': {
  //          required: true,
  //          username: true
  //        }
  //      },
  //      submitHandler: function(form){
  //
  //        $(form).ajaxSubmit({
  //          error: function(jqXHR, textStatus, errorThrown){
  //            _this.submitError.call(jqXHR, textStatus, errorThrown);
  //          },
  //          success: function(xhrData, textStatus, jqXHR){
  //            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
  //          }
  //        });
  //        return false;
  //      }
  //    });
  //
  //    $('#profile-form-realname').validate({
  //      rules: {
  //        'profile[realname]': {
  //          required: true
  //        }
  //      },
  //      submitHandler: function(form){
  //
  //        $(form).ajaxSubmit({
  //          error: function(jqXHR, textStatus, errorThrown){
  //            _this.submitError.call(jqXHR, textStatus, errorThrown);
  //          },
  //          success: function(xhrData, textStatus, jqXHR){
  //            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
  //          }
  //        });
  //        return false;
  //      }
  //    });
  //
  //    $('#profile-form-bio').validate({
  //      rules: {
  //        'profile[bio]': {
  //          required: true
  //        }
  //      },
  //      submitHandler: function(form){
  //
  //        $(form).ajaxSubmit({
  //          error: function(jqXHR, textStatus, errorThrown){
  //            _this.submitError.call(jqXHR, textStatus, errorThrown);
  //          },
  //          success: function(xhrData, textStatus, jqXHR){
  //            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
  //          }
  //        });
  //        return false;
  //      }
  //    });
  //
  //    $('#profile-form-url').validate({
  //      rules: {
  //        'profile[url]': {
  //          required: true,
  //          url: true
  //        }
  //      },
  //      submitHandler: function(form){
  //
  //        $(form).ajaxSubmit({
  //          error: function(jqXHR, textStatus, errorThrown){
  //            _this.submitError.call(jqXHR, textStatus, errorThrown);
  //          },
  //          success: function(xhrData, textStatus, jqXHR){
  //            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
  //          }
  //        });
  //        return false;
  //      }
  //    });

  },

  submitError: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },

  submitSuccess: function(xhrData, textStatus, jqXHR, model){
    var _this = this;
    if(xhrData.failed === true){
      alert(xhrData.error);
    }
    else{
      if(xhrData.error === true){
        alert(xhrData.error);
      }
      else{
        model.set($.extend(xhrData.content, {
          i: Date.now()
        }));
      }
    }
  }
});
