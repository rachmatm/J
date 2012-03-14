window.JotInputView = Backbone.View.extend({

  template: _.template($('#main-magicbox-jot-input-template').html()),

  events: {
    'click #jot-bar-write-more': 'open_write_more',
    'click #jot-bar-clip': 'open_clip',
    'click #jot-bar-location': 'open_location',
    'click #jot-bar-tag': 'open_tag'
  },

  initialize: function(){
    this.jotInputMoreContentView = new JotInputMoreContentView;
    this.holderView = new HolderView;
    this.jotInputClip = new JotInputClip;
    this.jotInputLocation = new JotInputLocation;
    this.jotInputTag = new JotInputTag;
  },

  createInputMoreHolder: function(id){
    this.holderView.setElement(this.jot_input_more_el);
    return this.holderView.renderPrependTo({
      idName: id,
      className: 'magicbox-jot-input-more'
    });
  },

  render: function(){
    $(this.el).html(this.template);
    this.setButtonAnimation();

    this.jot_input_more_el = $('#jot-input-more');

    this.write_more_present = 0;
    this.open_clip_present = 0;
    this.open_location_present = 0;
    this.open_tag_present = 0;
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
