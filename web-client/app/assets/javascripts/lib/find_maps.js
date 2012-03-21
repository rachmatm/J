$.fn.find_maps = function(params){
  var defaults = {
    source_url: '',
    on_item_click: function(item, $input_field){}
  };

  var options = $.extend(defaults, params);
  var holder = $('<div class="find-maps-holder"></div>').insertAfter(this);
  var input_field = this.appendTo(holder);
  var carousel_holder = $('<ul id="maps-carousel" class="jcarousel-skin-tango"></ul>').appendTo(holder);
  var carousel;
  var xhr_data;
  var map_data = [];


  return build();

  function build(){
    build_carousel();
  }

  function build_carousel(){
    carousel = carousel_holder.jcarousel({
      scroll:1,
      visible:1
    });

    input_field.bind('keyup', function(){
	  if(xhr_data) xhr_data.abort();
	  carousel.jcarousel('reset');
	  carousel.parents('.jcarousel-skin-tango').animate({height:120});
	  var keywords = $(this).val();

	  xhr_data = $.ajax({
        url: options.source_url + '?keywords=' + keywords,
        dataType: 'json',
        success: function(data, textStatus, jqXHR){
	      var totat_item;

	      if(data.length == 0){
		    close_carousel();
	      }
	      else{
	        $.each(data, function(index, map){
			  item_str = '<a href="#">'
				+ '<span class="find-maps-list-img"><img src="'+ map.img +'" alt="map"></span>'
			    + '<span class="find-maps-list-label">'+ map.label +'</span>'
			    + '</a>';

			  item = $(item_str).bind('click', function(){
				options.on_item_click.call(this, map, input_field);
			  });

			  carousel.jcarousel('add', index, item);
			  totat_item = index;
			 });

			 carousel.jcarousel('size', totat_item + 1);

			 $('<a href="#" class="close-find_maps"><span class="icon icon-colorbox-close"></span></a>').prependTo(carousel.parents('.jcarousel-skin-tango')).bind('click', function(){
				close_carousel();
			});
	      }
        }
	  });
    });
  }

  function close_carousel(){
    carousel.parents('.jcarousel-skin-tango').animate({height:0});
  }
}


$.fn.googlemaps = function(params){

  var defaults = {
    lat: '',
    lng: '',
    address: ''
  }

  var options = $.extend(defaults, params);

  return build();

  function build() {
	geocoder = new google.maps.Geocoder();
	var latlng = new google.maps.LatLng(options.lat, options.lng);

	var myOptions = {
	  zoom: 8,
	  center: latlng,
	  mapTypeId: google.maps.MapTypeId.ROADMAP
	}
	map = new google.maps.Map(document.getElementById("magic-box-maps-place-holder"), myOptions);

	var marker = new google.maps.Marker({map: map, position:  latlng});
  }
}