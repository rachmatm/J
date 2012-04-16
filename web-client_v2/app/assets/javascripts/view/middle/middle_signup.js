window.MiddleSignupView = Backbone.View.extend({

  template: _.template($('#signup-template').html()),

  initialize: function(){
    this.recaptchaView = new RecaptchaView;
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template());
    this.recaptchaView.setElement('#signup-recaptcha-holder');
    this.recaptchaView.render();
    this.validates();
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
        },
        'registration[password]': {
          required: true,
          minlength: 6
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
          beforeSend: function(jqXHR, settings){
            $(form).trigger('xhr:submit:before', [form]);
          },
          error: function(jqXHR, textStatus, errorThrown){
            $(form).trigger('xhr:submit:error', [form, textStatus]);
          },
          success: function(data, textStatus, jqXHR){
            $(form).trigger('xhr:submit:success', [form, $('#main-middle-signup-alert'), data]);
            
            if(data.failed === true){
              if(window.Recaptcha == 'undefined'){
                alert('Recaptcha is undefined');
              }
              else{
                Recaptcha.reload();
              }
            }
            else{
              $(window).trigger('auth:login', [data.content, data.token]);
            }
          }
        });

        return false;
      }
    });
  }
});