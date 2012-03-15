window.LoginView = Backbone.View.extend({
  
  template: _.template($('#main-magicbox-login-template').html()),

  events: {
    "click .link-to-registration": "open_registration",
    "click .link-forgot-password": "open_forgot"
  },

  initialize: function(){
   //
    this.forgotView = new ForgotView;
    this.registrationView = new RegistrationView;
    this.holderView = new HolderView;
    this.formView = new FormView;
    this.alertView = new AlertView;
    
    
  },

  render: function(){
    var _this = this;
    
    $(this.el).html(this.template);

    this.formView.setElement('#main-magicbox-login-form');

    this.formView.render({
      submitHandler: function(form){
        $(form).ajaxSubmit({
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              _this.alertView.remove();
              _this.alertView.render('authenticaion-alert',{
                error: data.error,
                errors: data.errors
              });
            }
            else{
              _this.alertView.remove();
              _this.alertView.render({
                notice: data.notice
              });
              location.href = '/';
            }
          },
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          }
        });
      }
    });
  },

  createHolder: function(id){
    this.holderView.setElement(this.el);
    return this.holderView.renderAppendTo({
      idName: id,
      className: 'magicbox-content-list'
    });
  },

  open_registration: function(){
    this.registrationView.remove();
    
    this.registrationView.setElement(this.createHolder('main-registration'));
    this.registrationView.render();
  },

  open_forgot: function(){
   
    this.forgotView.remove();
    this.forgotView.setElement(this.createHolder('main-forgot'));
    this.forgotView.render();
  }
});

