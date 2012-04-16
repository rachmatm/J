window.MiddleLoginCompletionView = Backbone.View.extend({

  template: _.template($('#login-completion-template').html()),

  initialize: function(){
    this.recaptchaView = new RecaptchaView;
    this.alertView = new AlertView;
    this.holderAlertView = new HolderView;
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template( CURRENT_USER ));

    this.recaptchaView.setElement('#signup-recaptcha-holder');
    this.recaptchaView.render();

    this.validates();

    this.elAlert = $('#main-middle-signup-alert');
  },

  validates: function(){
    var _this = this;

    $('#signup-form').validate({
      rules: {
        'registration[username]': {
          required: true,
          username: true,
          minlength: 5
        },
        'registration[realname]': {
          required: true
        },
        'registration[email]': {
          required: true,
          email: true
        }
      },
      messages: {},
      errorPlacement: function(error, element){
        var $alert_section = element.parents('tr').children('.main-registration-form-field-alert');

        $alert_section.children('.error').html(error).removeClass('hidden');
        $alert_section.children('.default_text').addClass('hidden');
      },
      success: function(label){
        var $alert_section = label.parents('.main-registration-form-field-alert');

        $alert_section.children('.error').addClass('hidden');
        $alert_section.children('.default_text').removeClass('hidden');
      },
      highlight: function(element, errorClass, validClass){
        var $el = $(element);
        $el.addClass(errorClass).removeClass(validClass);

        var $alert_section = $el.parents('tr').children('.main-registration-form-field-alert');

        $alert_section.children('.error').removeClass('hidden');
        $alert_section.children('.default_text').addClass('hidden');
      },
      unhighlight: function(element, errorClass, validClass){
        var $el = $(element);
        $el.removeClass(errorClass).addClass(validClass);

        var $alert_section = $el.parents('tr').children('.main-registration-form-field-alert');

        $alert_section.children('.error').addClass('hidden');
        $alert_section.children('.default_text').removeClass('hidden');
      },

      submitHandler: function(form){
        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            $(form).trigger('xhr:submit:error', [form, textStatus]);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              $(form).trigger('xhr:submit:success:false', [form, $('#alert-message-holder'), data]);

              if(window.Recaptcha == 'undefined'){
                alert('Recaptcha is undefined');
              }
              else{
                Recaptcha.reload();
              }

            }
            else{
              $(form).trigger('xhr:submit:success:true', [form]);
              $(window).trigger('auth:login', [data.content, data.token]);
            }
          },
          beforeSend: function(jqXHR, settings){
            $(form).trigger('xhr:submit:before', [form]);
          }
        });

        return false;
      }
    });
  }
});