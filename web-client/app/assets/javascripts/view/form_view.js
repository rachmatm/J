window.FormView = Backbone.View.extend({
  el: '',

  validate_options: {},

  render: function(_validate_options){
    this.validate_options = $.extend(this.validate_options, _validate_options);
    return $(this.el).validate(this.validate_options);
  }
});