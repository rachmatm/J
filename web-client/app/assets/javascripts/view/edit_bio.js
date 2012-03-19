window.EditBioView = Backbone.View.extend({

  template: _.template($('#main-magicbox-profile-bio').html()),

  initialize: function(){
    this.holderView = new HolderView;
    this.formView = new FormView;
    this.alertView = new AlertView;
    
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template);

    this.formView.setElement('.empty_bio_field');

    this.formView.render({
      submitHandler: function(form){
        $(form).ajaxSubmit({
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
              alert(data.notice);
            if(data.failed === true){
              _this.alertView.remove();
              _this.alertView.render('profile-alert',{
                error: data.error,
                errors: data.errors
              });
            }
            else{
              _this.alertView.remove();
              _this.alertView.render('profile-alert',{notice: data.notice });
              $('#form-current-bio').hide();
              $('#bioContent').show();
              $('#bioContent').html($('#bio').val());
              
            }
          },
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          }
        });
      }
    });
  }

})
