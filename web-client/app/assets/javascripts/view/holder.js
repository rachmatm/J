window.HolderView = Backbone.View.extend({
  template: _.template($('#holder-template').html()),

  template_variables: {
    className: '',
    idName: ''
  },

  renderAppendTo: function(variables){
    var _variables = $.extend({}, this.template_variables, variables);
    
    return $(this.template(_variables)).appendTo(this.el);
  },

  renderPrependTo: function(variables){
    var _variables = $.extend({}, this.template_variables, variables);
    
    return $(this.template(_variables)).prependTo(this.el);
  }
});