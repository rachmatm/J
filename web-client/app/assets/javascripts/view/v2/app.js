window.AppView = Backbone.View.extend({
  template: '',

  template_variables: {},

  render: function(variables){
    var _variables = $.extend({}, this.template_variables, variables);
    return $(this.template(_variables)).appendTo(this.el);
  }
});