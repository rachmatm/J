window.AppView = Backbone.View.extend({
  template: '',
  templateHolder: _.template($('#holder-template').html()),

  template_variables: {},

  render: function(variables){
    var _variables = $.extend({}, this.template_variables, variables);
    return $(this.template(_variables)).appendTo(this.el);
  }
});