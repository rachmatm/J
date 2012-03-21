window.FindLocation = AppView.extend({

  carouselHolderTemplate: '<ul id="maps-carousel" class="jcarousel-skin-tango"></ul>',

  default_options: {
    source: ''
  },

  initialize: function(options){
    this.default_options = $.extend({}, this.default_options, options);
    
    this.carousel = new Carousel;
  },

  render: function(){

    var carousel_el = $(this.carouselHolderTemplate).insertAfter(this.el);
    this.carousel.setElement(carousel_el);
    this.carousel.render({}, 'jot-find-location');
    this.carousel.reset();
    this.carousel.forceHide();
  },

  events: {
    'keydown': 'findLocation'
  },

  location_index: 0,

//  findLocation: function(event){
//
//    if(event.keyCode == 13){
//      $('<div><input type="text" name="jot[locations_attributes]['+ this.location_index +'][name]" value="'+ this.el.value +'"></div>').appendTo('#jot-input-location-list');
//      this.el.value = '';
//      this.location_index++;
//    }
//  },

  find_location_transport: '',

  findLocation: function(){
    var _this = this;

    if(!this.default_options.source){
      alert('source undifined');
      return false;
    }
    if(this.find_location_transport){
      this.find_location_transport.abort()
    }

    this.carousel.show();

    this.find_location_transport = $.ajax({
      url: this.default_options.source+ '?keywords=' + this.el.value,
      success: function(data, textStatus, jqXHR){


        $.each(data, function(){
          var item_str = '<a href="#">'
          + '<span class="find-maps-list-img"><img src="'+ this.img +'" alt="map"></span>'
          + '<span class="find-maps-list-label">'+ this.label +'</span>'
          + '</a>';

          _this.carousel.add(item_str);
        });

        if(_this.carousel.total_item == 0){
          _this.carousel.hide();
        }
      }
    })
  }

});