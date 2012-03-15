window.JotInputMoreContentView = Backbone.View.extend({
  template: _.template($('#main-magicbox-jot-input-more-content-template').html()),

  initialize: function(){
    this.formView = new FormView;
  },

  maxlenght: 512,

  render: function(){

    var _this = this;
    $(this.el).html(this.template());

    this.formView.setElement('#main-magicbox-jot-input-more-form');

    this.formView.render({
      rules: {
        'jot[detail]':{
          maxlength: _this.maxlenght
        }
      }
    });

    $('#jot-input-detail').bind('keyup', function(){
      $('#jot-input-more-text-length').text( _this.maxlenght - this.value.length)
    });
  }
});