window.RegistrationView = Backbone.View.extend({

  template: _.template($('#main-registration-template').html()),

  initialize: function(){
    this.formView = new FormView;
    this.recaptchaView = new RecaptchaView;
    this.alertView = new AlertView;
    this.holderView = new HolderView;
  },

  render: function(){
    var _this = this;
    
    $(this.el).html(this.template);

    this.formView.setElement('#main-registration-form');
    
    this.formView.render({
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
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              _this.alertView.remove();
              _this.alertView.render('registration-alert',{error: data.error, errors: data.errors});
              _this.recaptchaView.reload();
            }
            else{
              _this.alertView.remove();
              _this.alertView.render({notice: data.notice});
              location.href = '/';
            }
          },
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          }
        });
      }
    });

    this.recaptchaView.setElement('#registration-recaptcha');
    this.recaptchaView.render();
  }
});