window.RecaptchaView = Backbone.View.extend({

  public_id: "6LeUR80SAAAAAIIbp6Dt8D1jfZrF3gkn3DN3mVUP",

  source_url: "http://www.google.com/recaptcha/api/js/recaptcha_ajax.js",

  local_source_url: "/assets/recaptcha_ajax.js",

  render: function(){

    if(this.el && this.el.id){
      this.elId = this.el.id;
    }
    else if(this.el){
      this.elId = 'recaptcha' + Date.now();
    }
    else{
      return NaN;
    }

    var this_source_url = this.source_url;
    var this_local_source_url = this.local_source_url;
    var this_public_id = this.public_id;
    var this_elId = this.elId;

    yepnope([{
      test: window.Recaptcha,
      nope: this_source_url,
      complete: function () {
        if(!window.Recaptcha){
          yepnope(this_local_source_url);
        }

        Recaptcha.create(
          this_public_id,
          this_elId,
          {
            theme: "clean",
            callback: Recaptcha.focus_response_field
          }
          );
      }
    }]);
  },

  reload: function(){
    Recaptcha.reload();
  }
});