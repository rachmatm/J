window.AlertView = Backbone.View.extend({
  
  template: _.template($('#alert-template').html()),

  initialize: function(){
    this.holderView = new HolderView;
  },

  createHolder: function(id){
    this.holderView.setElement('#global-alert');
    return this.holderView.renderPrependTo({idName: id, className: 'registration-alert'});
  },

  template_parameters: {
    error: '',
    errors: [],
    notice: '',
    info: ''
  },
  
  render: function(id, parameters){
    this.setElement(this.createHolder(id));

    $(this.el).html(this.template($.extend({},this.template_parameters, parameters))).animate({opacity:0}, 5000, function(){
      $(this).remove();
    });
  }
});