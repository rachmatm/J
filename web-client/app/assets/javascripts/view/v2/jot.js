window.JotView = AppView.extend({

  template: _.template($('#main-listing-jot-item-template').html()),
  
  inputMoreTemplate: _.template($('#main-magicbox-jot-input-more-content-template').html()),

  inputLocationTemplate: _.template($('#main-magicbox-jot-input-location-template').html()),

  inputClipTemplate: _.template($('#main-magicbox-jot-input-clip-template').html()),

  el: $('#main-content'),

  initialize: function(options) {
    this.options = options;
    var _this = this;
    
    //this.input = this.$("#new-todo");
    this.jots = new JotCollection;
    
    this.appHolderView = new AppHolderView;

    this.findLocation = new FindLocation({
      source: '/maps.json'
    });

    this.jotAddClip = new JotAddClip;

    this.jots.bind('add', this.renderOneItemReverse, this);
    this.jots.bind('all', this.render, this);
    this.jots.bind('reset', this.renderAllItem, this);
    
    this.get({
      timestamp: 'now'
    });

    $('.link-to-rejot').live('click', function(){
      $.ajax({
        url: this.href,

        success: function(data, textStatus, jqXHR){
          if(data.failed === true){
            alert(data.error);
          }
          else{
            _this.jots.add(data.content);

          }
        },

        error: function(jqXHR, textStatus, errorThrown){
          alert("Thumbsup action failed: " + textStatus)
        }
      });
      return false;
    });
  },

  get: function(params){
    this.jots.fetch({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
      },
      data:{
        jot:{
          timestamp: params.timestamp,
          per_page: 1
        }
      }
    });
  },

  render: function(){
    this.setButtonAnimation();
    this.setFormSubmission();
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

  maxlength: 140,

  setFormSubmission: function(){
    var _this = this;

    $('#main-magicbox-jot-input-form').validate({
      rules: {
        'jot[title]' : {
          required: true,
          maxlength: _this.maxlength
        }
      },

      errorPlacement: function(error, element){},

      submitHandler: function(form){
        $(form).ajaxSubmit({
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              alert(data.error);
            }
            else{
              _this.jots.add(data.content);
            }
          },

          beforeSend: function(){
          }
        });

        return false;
      }
    });

    $('#jot-search-field').bind('keyup', function(){
      $('#jot-input-text-length').text( _this.maxlength - this.value.length);
    });
  },

  renderAllItem: function(){
    var _this = this;
    
    this.jots.each(function(data){
      _this.renderOneItem(data);
    })
  },

  renderOneItem: function(data, reverse){
    var jot = data.toJSON();
    var _this = this;

    var faved = in_array(jot._id, this.options.jot_favorite_ids);
    
    this.appHolderView.setElement('#main-content-middle-jot-list');
    
    var el = this.appHolderView.render({
      idName: 'main-content-middle-jot-list-item-'+ jot._id,
      className: 'main-content-middle-jot-list-item'
    }, reverse);
    
    this.jotItem = new JotItem({
      model: data,
      jot_thumbs_up_ids: _this.jot_thumbs_up_ids
    });
    this.jotItem.setElement(el);


    this.jotItem.render($.extend(jot, {
      faved: faved
    }));
  },

  renderOneItemReverse: function(data){
    this.renderOneItem(data, true);
  },

  events: {
    'click #jot-bar-write-more': 'open_write_more',
    'click #jot-bar-clip': 'open_clip',
    'click #jot-bar-location': 'open_location',
    'click #jot-bar-tag': 'open_tag',
    'click #jot-bar-facebook': 'open_facebook',
    'click #jot-bar-twitter': 'open_twitter',
    'click .show-more-list-jot': 'show_more'
  },

  createMoreInputHolder: function(id){
    this.appHolderView.setElement('#jot-input-more');
    
    return this.appHolderView.render({
      idName: 'main-content-tab-jot-input-'+ id,
      className: 'main-content-tab-jot-input'
    }, true);
  },

  open_write_more_el: '',

  detail_maxlength: 512,

  open_write_more: function(){
    var _this = this;

    if(this.open_write_more_el){
      this.open_write_more_el.remove();
      this.open_write_more_el = '';
    }
    else{
      this.open_write_more_el = this.createMoreInputHolder('more');
      
      $(this.open_write_more_el).html(this.inputMoreTemplate());

      $("#jot-input-detail").rules("add", {
        maxlength: this.detail_maxlength
      });

      $("#jot-input-detail").bind('keyup', function(){
        $('#jot-input-more-text-length').text(_this.detail_maxlength - this.value.length);
      });
    }
    return false;
  },

  open_clip_el: '',

  open_clip: function(){
    var _this = this;

    if(this.open_clip_el){
      this.open_clip_el.remove();
      this.open_clip_el = '';
    }
    else{
      this.open_clip_el = this.createMoreInputHolder('clip');
      $(this.open_clip_el).html(this.inputClipTemplate);

      this.jotAddClip.setElement('#field-to-attachment');
      this.jotAddClip.render();
    }
  },

  open_location_more_el: '',

  open_location: function(){
    var _this = this;

    if(this.open_location_more_el){
      this.open_location_more_el.remove();
      this.open_location_more_el = '';
    }
    else{
      this.open_location_more_el = this.createMoreInputHolder('more');
      $(this.open_location_more_el).html(this.inputLocationTemplate);

      this.findLocation.setElement('#field-to-location');
      this.findLocation.render();

    //      $('#field-to-location').find_maps({
    //        source_url: "/maps",
    //        on_item_click: function(item, $input_field){
    //          $('#jot_location_latitude').val(item.lat);
    //          $('#jot_location_longitude').val(item.lng);
    //
    //          var result_holder = $('#jot-map-thumb-result');
    //          var result_thumb_holder = result_holder.find('.jot-map-thumb');
    //          var result_label_holder = result_holder.find('.jot-map-label-field');
    //
    //          result_thumb_holder.html('<img src="'+ item.img +'" alt="'+ item.label +'">');
    //
    //          result_label_holder.val(item.label);
    //
    //          result_holder.removeClass('hidden');
    //        }
    //      });
    }
  },
  
  open_tag: function(){
    
  },
  
  open_facebook: function(){
    
  },

  open_twitter: function(){
    
  },

  show_more: function(){
    if(this.jots.length == 0){
      $('.show-more-list-jot').hide();
    }
    else{
      var data = this.jots.toJSON();
      var data_last = _.last(data);

      this.get({
        timestamp: data_last.updated_at
      });
    }
  }
});