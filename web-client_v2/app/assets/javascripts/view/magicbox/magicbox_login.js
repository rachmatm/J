window.MagicboxLoginView = Backbone.View.extend({

  default_options: {
    elNav: '',
    el: ''
  },

  initialize: function(options){
    this.options = $.extend({}, this.default_options, options);
    this.alertView = new AlertView;
    this.holderAlertView = new HolderView;

    this.validates();

    this.elAlert = $('#alert-message-holder');
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
  },

  open: function(){
    $(this.options.elNav).addClass('login');
    $(this.options.el).removeClass('hidden');
  },

  close: function(){
    $(this.options.elNav).removeClass('login');
  }
})