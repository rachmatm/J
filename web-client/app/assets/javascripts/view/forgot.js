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
         rules: {},
         messages: {},
         errorPlacement: function(error, element){},
         success: function(label){},
         highlight: function(element, errorClass, validClass){},
         unhighlight: function(element, errorClass, validClass){},
         submitHandler: function(form){
            $(form).ajaxSubmit({
                dataType: 'json',
                success: function(data, textStatus, jqXHR){},
                error: function(jqXHR, textStatus, errorThrown){
                    alert(textStatus);
                }
            })
         }
    })
        
  }

});