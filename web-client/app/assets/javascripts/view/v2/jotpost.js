/*
window.AboutView = Backbone.View.extend({
    
  template: _.template($('#main-about-template').html()),

  render: function(){
    
    $(this.el).html(this.template);
  }
});
*/

window.JotpostView = AppView.extend({
  template: _.template($('#mmain-jotpost-template').html())
});