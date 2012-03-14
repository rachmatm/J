window.HolderView = Backbone.View.extend({
  template: _.template($('#holder-template').html()),

  renderAppendTo: function(attributes){
    return $(this.template(attributes || {})).appendTo(this.el);
  },

  renderPrependTo: function(attributes){
    return $(this.template(attributes || {})).prependTo(this.el);
  }
});