window.EditLocationView = Backbone.View.extend({

  template: _.template($('#main-magicbox-profile-location').html()),

  initialize: function(){
    this.holderView = new HolderView;
    this.formView = new FormView;
    this.alertView = new AlertView;

  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template);

    this.formView.setElement('.empty_location_field');

    this.formView.render({
      submitHandler: function(form){
        $(form).ajaxSubmit({
          dataType: 'json',
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              _this.alertView.remove();
              _this.alertView.render('profile-alert',{
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
  }

})
