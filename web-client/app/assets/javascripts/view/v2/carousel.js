window.Carousel = AppView.extend({

  default_options: {
    scroll:1,
    visible:1
  },

  total_item: 0,

  render: function(params, className){
    var _opt = $.extend({}, this.default_options, params);

    this.total_item = 0;
    this.carousel = $(this.el).jcarousel(_opt);

    this.holder = this.carousel.parents('.jcarousel-container').parent();
    this.holder.addClass(className);
  },

  add: function(str_html){
    this.carousel.jcarousel('add', this.total_item,  str_html);
    this.total_item++;
    this.carousel.jcarousel('size', this.total_item);
  },

  reset: function(){
    this.carousel.jcarousel('reset');
  },

  hide: function(){
    this.holder.fadeOut();
  },

  show: function(){
    this.holder.fadeIn();
  },

  forceHide: function(){
     this.holder.hide();
  }
})