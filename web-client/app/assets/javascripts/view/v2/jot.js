window.JotView = AppView.extend({

  template: _.template($('#main-listing-jot-item-template').html()),
  
  inputMoreTemplate: _.template($('#main-magicbox-jot-input-more-content-template').html()),

  inputLocationTemplate: _.template($('#main-magicbox-jot-input-location-template').html()),

  el: $('#main-content'),

  initialize: function() {
    //this.input = this.$("#new-todo");
    this.jots = new JotCollection;
    
    this.appHolderView = new AppHolderView;
    
    this.jotItem = new JotItem;

    this.jots.bind('add', this.renderOneItemReverse, this);
    this.jots.bind('reset', this.render, this);
    this.jots.bind('all', this.renderAllItem, this);
    
    this.jots.fetch({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
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

            $(form).find('input textarea').removeAttr('disabled');
          },

          beforeSend: function(){
            $(form).find('input textarea').attr({
              'disabled': 'disabled'
            });
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

    this.appHolderView.setElement('#main-content-middle-jot-list');
    var el = this.appHolderView.render({
      idName: 'main-content-middle-jot-list-item-'+ jot._id,
      className: 'main-content-middle-jot-list-item'
    }, reverse);

    this.jotItem.setElement(el);

    this.jotItem.render(jot);
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
    'click #jot-bar-twitter': 'open_twitter'
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

  open_clip: function(){
    
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
    }
  },
  
  open_tag: function(){
    
  },
  
  open_facebook: function(){
    
  },

  open_twitter: function(){
    
  }

});