window.MagicboxSettingView = Backbone.View.extend({

  template: _.template($('#magicbox-setting-template').html()),

  initialize: function(){
    this.profiles = new ProfileCollection;
    this.profiles.bind('reset', this.setData, this);
    this.profiles.bind('change', this.setTemplate, this);

    this.connections = new ConnectionCollection;
    this.connections.bind('add', this.addConnection, this);
    this.connections.bind('all', this.renderConnection, this);
    this.connections.bind('reset', this.resetConnection, this);
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

    $('#magicbox-setting-content').html(this.template(data.toJSON()));

    this.connections.fetch();

    $('.show-hide-edit-panel-display').bind('click', function(){
      $(this).addClass('hidden').
      parent().
      children('.show-hide-edit-panel-input').removeClass('hidden');
    });


    $('#setting-form-username').validate({
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

    $('#setting-form-realname').validate({
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

    $('#setting-form-email').validate({
      rules: {
        'profile[email]': {
          required: true
        }
      },
      errorPlacement: function(){},
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

    $('#setting-form-password').validate({
      rules: {
        'profile[password]': {
          required: true,
          minlength: 6,
          equalTo: '#profile_password_confirmation'
        }
      },
      errorPlacement: function(){},
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

    $('#setting-form-privacy').validate({
      rules: {
        'profile[setting_privacy_jot]': {
          required: true
        },
        'profile[setting_privacy_location]': {
          required: true
        },
        'profile[setting_privacy_kudos]': {
          required: true
        }
      },
      errorPlacement: function(){},
      
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

    $('#setting-form-auto').validate({
      rules: {
        'profile[setting_auto_complete]': {
          required: true
        },
        'profile[setting_auto_shorten_url]': {
          required: true
        }
      },
      errorPlacement: function(){},
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

    $('#setting-form-conn').validate({
      rules: {},
      errorPlacement: function(){},
      submitHandler: function(form){

        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            _this.submitError.call(jqXHR, textStatus, errorThrown);
          },
          success: function(xhrData, textStatus, jqXHR){
            _this.connections.fetch();
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
  },

  addConnection: function(data){
    this.connection(data, true)
  },

  connection: function(data, reverse){
    this.listView = new ListView({
      model: data
    });
    this.listView.setElement('#setting-crosspost-table tbody')
    this.listView.openConnection(reverse);
  },

  resetConnection: function(){
    var _this = this;

    $('#setting-crosspost-table tbody').children().remove();

    this.connections.each(function(data){
      _this.connection(data);
    });
  },

  renderConnection: function(data){
    
  }
})