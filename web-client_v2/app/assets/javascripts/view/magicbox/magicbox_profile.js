window.MagicboxProfileView = Backbone.View.extend({

  template: _.template($('#magicbox-profile-template').html()),

  initialize: function(){
    this.profiles = new ProfileCollection;
    this.profiles.bind('reset', this.setData, this);
    this.profiles.bind('change', this.setTemplate, this);
  },

  render: function(){
    $(this.el).removeClass('hidden');
    this.profiles.fetch();
  },

  setData: function(){
    var _this = this;

    this.profiles.each(function(data){
      _this.setTemplate(data);
    });
  },

  setTemplate: function(data){
    var _this = this;

    $('#magicbox-profile-content').html(this.template(data.toJSON()));

    $('.show-hide-edit-panel-display').bind('click', function(){
      $(this).addClass('hidden').
      parent().
      children('.show-hide-edit-panel-input').removeClass('hidden');
    });


    $('#profile-form-username').validate({
      rules: {
        'profile[username]': {
          required: true,
          username: true
        }
      },
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
          }
        });
        return false;
      }
    });

    $('#profile-form-realname').validate({
      rules: {
        'profile[realname]': {
          required: true
        }
      },
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
          }
        });
        return false;
      }
    });

    $('#profile-form-bio').validate({
      rules: {
        'profile[bio]': {
          required: true
        }
      },
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
          }
        });
        return false;
      }
    });

    $('#profile-form-url').validate({
      rules: {
        'profile[url]': {
          required: true,
          url: true
        }
      },
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
          }
        });
        return false;
      }
    });

    $('#profile-form-location').validate({
      rules: {
        'profile[location]': {
          required: true
        }
      },
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.submitSuccess.call(_this, xhrData, textStatus, jqXHR, data);
          }
        });
        return false;
      }
    });

    
  },

  submitError: function(jqXHR, textStatus, errorThrown){
    alert(textStatus);
  },

  submitSuccess: function(xhrData, textStatus, jqXHR, model){
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