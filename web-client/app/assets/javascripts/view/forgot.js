window.ForgotView = Backbone.View.extend({

  template: _.template($('#main-forgot-template').html()),

  initialize: function(){

    this.formView   = new FormView;
    this.alertView  = new AlertView;
    this.holderView = new HolderView;
  },

  render: function(){
    var _this = this;
    $(this.el).html(this.template);
    this.formView.setElement('#main-forgot-form');

    this.formView.render({
         rules: {
             'forgot[email]': {
          required: true,
          email: true
        }
         },
         messages: {},
         errorPlacement: function(error, element){
              var $alert_section = element.parents('tr').children('.main-forgot-form-field-alert');
                $alert_section.children('.error').html(error).removeClass('hidden');
                $alert_section.children('.default_text').addClass('hidden');
         },
         success: function(label){
             var $alert_section = label.parents('.main-forgot-form-field-alert');
            $alert_section.children('.error').addClass('hidden');
            $alert_section.children('.default_text').removeClass('hidden');
         },
         highlight: function(element, errorClass, validClass){
              var $el = $(element);
                $el.addClass(errorClass).removeClass(validClass);
                var $alert_section = $el.parents('tr').children('.main-forgot-form-field-alert');
                $alert_section.children('.error').removeClass('hidden');
                $alert_section.children('.default_text').addClass('hidden');
         },
         unhighlight: function(element, errorClass, validClass){
             var $el = $(element);
        $el.removeClass(errorClass).addClass(validClass);

        var $alert_section = $el.parents('tr').children('.main-forgot-form-field-alert');

        $alert_section.children('.error').addClass('hidden');
        $alert_section.children('.default_text').removeClass('hidden');
         },
         submitHandler: function(form){
            $(form).ajaxSubmit({
                dataType: 'json',
                success: function(data, textStatus, jqXHR){

                    if(data.failed === true){
              _this.alertView.remove();
              _this.alertView.render('forgot-alert',{error: data.error, errors: data.errors});

            }
            else{
                alert(data.notice);
              _this.alertView.remove();
              _this.alertView.render('forgot-alert',{notice: data.notice});

            }
                },
                error: function(jqXHR, textStatus, errorThrown){
                    alert(textStatus);
                }
            })
         }
    })

  }

});