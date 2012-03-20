window.BioView = Backbone.View.extend({
  template: _.template($('#main-magicbox-profile-bio').html()),
  
  initialize: function(){

    this.formView   = new FormView;
    this.alertView  = new AlertView;
    this.holderView = new HolderView;
  },
  
   render: function(){
    var _this = this;
    $(this.el).html(this.template);
    this.formView.setElement('#form-current-bio');

    this.formView.render({
         rules: {
             'user[bio]': {required: true }
        },

        submitHandler: function(form){
        $(form).ajaxSubmit({
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
              alert('send');
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
       
    })

   }
});