window.MagicboxLoginView = Backbone.View.extend({

  initialize: function(options){
    this.elNav = $('#magicbox-navigation-login');
    this.el = $('#magicbox-login');
    this.validates();
  },

  validates: function(){
    var _this = this;

    $('#login-form').validate({
      rules: {
        'authentication[username]': {
          required: true
        },

        'authentication[password]': {
          required: true
        }
      },
      errorPlacement: function(){},

      submitHandler: function(form){
        
        $(form).ajaxSubmit({
          beforeSend: function(jqXHR, settings){
            $(form).trigger('xhr:submit:before', [form]);
          },
          error: function(jqXHR, textStatus, errorThrown){
            $(form).trigger('xhr:submit:error', [form, textStatus]);
          },
          success: function(data, textStatus, jqXHR){
            $(form).trigger('xhr:submit:success', [form, $('#alert-message-holder'), data]);
            
            if(!data.failed === true){
              $(window).trigger('auth:login', [data.content, data.token]);
            }
          }
        });
      }
    });
  },

  open: function(){
    $(this.elNav).addClass('login');
    $(this.el).removeClass('hidden');
  },

  close: function(){
    $(this.elNav).removeClass('login');
  }
})