$.fn.formatted_field = function(options){

  var defaults = {}

  var options = $.extend(defaults, options);
  var view_holder;
  var view_holder_inner;
  var input_holder;
  var dheight;
  var dwidth;

  return build(this);


  function build(obj){

    view_holder = $(obj).find('.formated-field-view');
    view_holder_inner = $(obj).find('.formated-field-view-inner');
    input_holder = $(obj).find('.formated-field-input');

    
    // init
    setHeightNWidth(obj, view_holder, input_holder);

    dheight = $(input_holder).outerHeight( true );
    dwidth = $(input_holder).outerWidth( true );
    $(view_holder).css({
      height: dheight,
      width: dwidth
    });
    $(obj).css({
      height: dheight,
      width: dwidth
    });

    $(input_holder).bind('resize', function(){
      setHeightNWidth(obj, view_holder, input_holder)
    });

    $(input_holder).bind('keyup', function(e){

      var view_text = this.value.replace(/\n\r?/g, '<br />');

      var myregexp = new RegExp(/\/F\/(.\S*)/)
      var myregexpresult = myregexp.exec(view_text)

      if(myregexpresult){
        view_text = view_text.replace(myregexpresult[0], '<span class="ff-crosspost">' + myregexpresult[0] + '</span>')
      }

      $(view_holder_inner).html(nl2br(view_text));
    });
  }


  function setHeightNWidth(obj, view_holder, input_holder){
    dheight = $(input_holder).outerHeight( true );
    dwidth = $(input_holder).outerWidth( true );
    $(view_holder).css({
      height: dheight,
      width: dwidth
    });
    $(obj).css({
      height: dheight,
      width: dwidth
    });
  }
}