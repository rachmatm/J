window.RecaptchaView = Backbone.View.extend({

  default_options: {
    your_public_key: '6LeUR80SAAAAAIIbp6Dt8D1jfZrF3gkn3DN3mVUP',
    theme: "clean"
  },

  initialize: function(options){
    this.options = $.extend({}, this.default_options, options); 
  },

  render: function(){
    $(this.el).text('please wait..');
    Recaptcha.create( this.options.your_public_key, this.el.id,{ theme: this.options.theme, callback: Recaptcha.focus_response_field});
  }
});