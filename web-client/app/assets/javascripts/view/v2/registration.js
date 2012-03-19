window.RegistrationView2 = AppView.extend({
  template: _.template($('#main-registration-template').html()),

  initialize: function(){
    this.recaptchaView = new RecaptchaView;
  },

  render_recaptcha: function(){
    this.recaptchaView.setElement('#registration-recaptcha');
    this.recaptchaView.render();
  }
});