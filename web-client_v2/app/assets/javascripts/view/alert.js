window.AlertView = Backbone.View.extend({

  template: _.template($('#alert-template').html()),

  default_variables: {
    error: '',
    errors: [],
    notice: '',
    info: ''
  },

  render: function(variables){
    $(this.el).append(this.template( $.extend({}, this.default_variables, variables) ));
    return this;
  }
})