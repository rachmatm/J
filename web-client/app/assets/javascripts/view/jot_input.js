window.JotInputView = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-template').html()),

  events: {
    'click #jot-bar-write-more': 'open_write_more',
    'click #jot-bar-clip': 'open_clip',
    'click #jot-bar-location': 'open_location',
    'click #jot-bar-tag': 'open_tag'
  },

  maxlenght: 140,

  initialize: function(){
    this.jotInputMoreContentView = new JotInputMoreContentView;
    this.holderView = new HolderView;
    this.jotInputClip = new JotInputClip;
    this.jotInputLocation = new JotInputLocation;
    this.jotInputTag = new JotInputTag;
    this.formView = new FormView;
    this.jotListing = new JotListing;
    this.jotCollection = new JotCollection;
  },

  createListHolder: function(id){
    this.holderView.setElement(this.el);
    return this.holderView.renderAppendTo({
      idName: id,
      className: 'magicbox-jot-list'
    });
  },

  createInputMoreHolder: function(id){
    this.holderView.setElement(this.jot_input_more_el);
    return this.holderView.renderPrependTo({
      idName: id,
      className: 'magicbox-jot-input-more'
    });
  },

  render: function(){
    var _this = this;
    
    $(this.el).html(this.template);
    this.setButtonAnimation();

    this.jot_input_more_el = $('#jot-input-more');

    this.write_more_present = 0;
    this.open_clip_present = 0;
    this.open_location_present = 0;
    this.open_tag_present = 0;

    this.formView.setElement('#main-magicbox-jot-input-form');

    this.formView.render({
      rules: {
        'jot[title]' : {
          required: true,
          maxlength: _this.maxlenght
        }
      },

      errorPlacement: function(error, element){}
    });

    $(this.formView.el).bind('submit', function(){
      var valid_input = false;
      var $form_inputs = $(_this.el).find('.main-magicbox-jot-input-form');
      var input_params = {};

      $form_inputs.each(function(index, form){
        if($(form).valid() === true){
          valid_input++;
          var _input_params = {};

          if(index > 1){
            $.each($(form).serializeArray(), function(i, field) {
              _input_params[field.name] = encodeURI(encodeURIComponent(field.value));
            });

            $.extend(input_params, _input_params);
          }
        }
      });

      if($form_inputs.length == valid_input){
        $(this).ajaxSubmit({
          success: function(data, textStatus, jqXHR){
            _this.jotListing.create_item(data.content);
          },
          error: function(jqXHR, textStatus, errorThrown){
            alert('Jot posting failed: '+ textStatus +'');
          },
          data: input_params
        });
      }

      return false;
    });

    $('#jot-input-title').bind('keyup', function(){
      $('#jot-input-text-length').text(_this.maxlenght - this.value.length)
    });

    this.jotListing.setElement(this.createListHolder('main-magicbox-jot-list'));
    this.jotListing.render();

    

    var _this = this;

    this.jotCollection.fetch({
      success: function(){
        var jots = _this.jotCollection.toJSON();

        $.each(jots, function(){
          _this.jotListing.create_item(this);
        });
      }
    });
  },

  setButtonAnimation: function(){
    var buttons = $(this.el).find('.jot-bar-button');

    buttons.hover(
      function(){
        $(this).addClass('jot_hover');
      },
      function(){
        $(this).removeClass('jot_hover');
      });

    buttons.bind('click', function(){
      $(this).toggleClass('jot_click jot_click_active');
    });
  },

  open_write_more: function(){
    if(this.write_more_present){
      this.jotInputMoreContentView.remove();
      this.write_more_present = 0;
    }
    else{
      this.jotInputMoreContentView.setElement(this.createInputMoreHolder('jot-input-more-content'));
      this.jotInputMoreContentView.render();
      this.write_more_present = 1;
    }

    this.open_more_content_close_button();
  },

  open_clip: function(){
    if(this.open_clip_present){
      this.jotInputClip.remove();
      this.open_clip_present = 0;
    }
    else{
      this.jotInputClip.setElement(this.createInputMoreHolder('jot-input-clip'));
      this.jotInputClip.render();
      this.open_clip_present = 1;
    }

    this.open_more_content_close_button();
  },

  open_location: function(){
    if(this.open_location_present){
      this.jotInputLocation.remove();
      this.open_location_present = 0;
    }
    else{
      this.jotInputLocation.setElement(this.createInputMoreHolder('jot-input-location'));
      this.jotInputLocation.render();
      this.open_location_present = 1;
    }

    this.open_more_content_close_button();
  },

  open_tag: function(){
    if(this.open_tag_present){
      this.jotInputTag.remove();
      this.open_tag_present = 0;
    }
    else{
      this.jotInputTag.setElement(this.createInputMoreHolder('jot-input-tag'));
      this.jotInputTag.render();
      this.open_tag_present = 1;
    }

    this.open_more_content_close_button();
  },

  open_more_content_close_button: function(){
    if($(this.jot_input_more_el).children('.magicbox-jot-input-more').length > 0){
      $(this.jot_input_more_el).addClass('show_more');
    }
    else{
      $(this.jot_input_more_el).removeClass('show_more');
    }
  }
});
