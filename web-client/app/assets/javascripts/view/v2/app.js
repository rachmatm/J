window.AppView = Backbone.View.extend({
  template: '',

  template_variables: {},

  render: function(variables, reverse){
    var _variables = $.extend({}, this.template_variables, variables);

    if(reverse){
      return $(this.template(_variables)).prependTo(this.el);
    }
    else{
      return $(this.template(_variables)).appendTo(this.el);
    }
  }
});