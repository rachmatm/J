window.MiddleForgotPasswordView = Backbone.View.extend ({

  template: _.template($('#forgot-password-template').html()),

  initialize: function(){
    this.alertView = new AlertView;
    this.holderAlertView = new HolderView;
  },

  render: function(data){
    var _this = this;

    $(this.el).html(this.template(data));

    this.validates();

    this.elAlert = $('#main-middle-forgot-password-alert');
  },

  validates: function(){
    var _this = this;

    $('#forgot-password-form').validate({
      rules: {
        'forgot_password[email]': {
          required: true,
          minlength: 6
        }
      },
      messages: {},
      errorPlacement: function(error, element){
        var $alert_section = element.parents('tr').children('.main-forgot-password-form-field-alert');

        $alert_section.children('.error').html(error).removeClass('hidden');
        $alert_section.children('.default_text').addClass('hidden');
      },
      success: function(label){
        var $alert_section = label.parents('.main-forgot-password-form-field-alert');

        $alert_section.children('.error').addClass('hidden');
        $alert_section.children('.default_text').removeClass('hidden');
      },
      highlight: function(element, errorclass, validclass){
        var $el = $(element);
        $el.addClass(errorclass).removeClass(validclass);

        var $alert_section = $el.parents('tr').children('.main-forgot-password-form-field-alert');

        $alert_section.children('.error').removeClass('hidden');
        $alert_section.children('.default_text').addClass('hidden');
      },
      unhighlight: function(element, errorclass, validclass){
        var $el = $(element);
        $el.removeClass(errorclass).addClass(validclass);

        var $alert_section = $el.parents('tr').children('.main-forgot-password-form-field-alert');

        $alert_section.children('.error').addClass('hidden');
        $alert_section.children('.default_text').removeClass('hidden');
      },

      submitHandler: function(form){
        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              _this.alertView.remove();

              _this.holderAlertView.setElement(_this.elAlert);
              _this.holderAlertView.render({
                classname: 'holder-view-alert'
              });

              _this.alertView.setElement(_this.holderAlertView.holder_el);
              _this.alertView.render({
                error: data.error,
                errors: data.errors
              });

            }
            else{
              _this.alertView.remove();

              _this.holderAlertView.setElement(_this.elAlert);
              _this.holderAlertView.render({
                classname: 'holder-view-alert'
              });

              _this.alertView.setElement(_this.holderAlertView.holder_el);
              _this.alertView.render({
                notice: data.notice
              });
              //$(window).trigger('jotky_login', data.content.token);
            }
          }
        });

        return false;
      }
    });
  }
})
