window.LoginView = Backbone.View.extend({

  elAlert: $('#alert-message-holder'),

  default_options: {
    el: this.elLogin,
    elForm: this.elLoginForm
  },

  initialize: function(options){
    this.default_options = $.extend({}, this.default_options, options);

    this.el = this.default_options.el;
    this.elForm = this.default_options.elForm;

    this.alertView = new AlertView;
    this.holderAlertView = new HolderView;


    this.validates();
  },

  validates: function(){
    var _this = this;

    $(this.elForm).validate({
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
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              _this.alertView.remove();

              _this.holderAlertView.setElement(_this.elAlert);
              _this.holderAlertView.render({
                className: 'holder-view-alert'
              });

              _this.alertView.setElement(_this.holderAlertView.holder_el);
              _this.alertView.render({
                error: data.error,
                errors: data.errors
              });

            }
            else{
              _this.alertView.remove();

              $(window).trigger('jotky_login', data.content.token);
            }
          }
        });
      }
    });
  }
});
