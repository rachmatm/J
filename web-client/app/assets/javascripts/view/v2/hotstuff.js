/*
window.AboutView = Backbone.View.extend({
    
  template: _.template($('#main-about-template').html()),

  render: function(){
    
    $(this.el).html(this.template);
  }
});
*/

window.HotstuffView = AppView.extend({
  template: _.template($('#main-hotstuff-template').html())
});