window.AboutView = Backbone.View.extend({
  
  template: _.template($('#main-about-template').html()),

  events: {
    "click .about_default": "open_registration",
    "click .what_jotky_default": "open_forgot"
  },

 

  createHolder: function(id){
    this.holderView.setElement(this.el);
    return this.holderView.renderAppendTo({
      idName: id,
      className: 'magicbox-content-list'
    });
  },

  open_registration: function(){
   alert('ridha');
  },

  open_forgot: function(){
   this.registrationView.remove();
    this.forgotView.remove();
    this.forgotView.setElement(this.createHolder('main-forgot'));
    this.forgotView.render();
  }
});

