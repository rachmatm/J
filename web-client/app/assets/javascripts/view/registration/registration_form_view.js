window.RegistrationFormView = FormView.extend({

  template: _.template($('#main-registration').html()),

  initialize: function(_validate_options){
    
    $('#main-content').append(this.template);

    this.setValidation();
    this.setRecaptcha();
  },


  setValidation : function(){
    this.el = $('#main-registration-form');

    this.render({
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
          success: function(data, textStatus, jqXHR){

          },
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          }
        });
      }
    });
  },

  setRecaptcha: function(){

    yepnope([{
      load: 'http://www.google.com/recaptcha/api/js/recaptcha_ajax.js',
      complete: function () {
        if(!window.Recaptcha){
          yepnope('/assets/recaptcha_ajax.js');
        }

        Recaptcha.create(
          "6LeUR80SAAAAAIIbp6Dt8D1jfZrF3gkn3DN3mVUP",
          "registration-recaptcha",
          {
            theme: "clean",
            callback: Recaptcha.focus_response_field
          }
          );
      }
    }]);
  }
});