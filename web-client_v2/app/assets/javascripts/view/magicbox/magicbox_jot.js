window.MagicboxJotView = Backbone.View.extend({

  default_options: {
    elNav: '',
    el: ''
  },

  jot_title_maxlength: 140,

  jot_more_maxlength: 512,

  initialize: function(options){
    this.current_length_holder = $('#jot-input-text-length');

    this.current_more_length_holder = $('#jot-input-more-text-length');

    this.options = $.extend({}, this.default_options, options);

    this.jots = new JotCollection;
    this.jots.bind('add', this.addItem, this);
    this.jots.bind('all', this.renderItem, this);
    this.jots.bind('reset', this.resetItem, this);

    this.middleView = new MiddleView({
      model: this.jots
    });
    this.middleView.setElement('#main-middle');

    this.validates();

    this.connections = new ConnectionCollection;
    this.setButtonAnimation();
    this.setClipField();
    this.setJotTagField();

    this.needResetAfterSubmit();
  },

  needResetAfterSubmit: function(){
    $(this.current_length_holder).text(this.jot_title_maxlength);
    $(this.current_more_length_holder).text(this.jot_more_maxlength);
  },

  validates: function(){
    var _this = this;

    this.validates = $('#jots-form').validate({
      rules: {
        'jot[title]': {
          required: true,
          maxlength: _this.jot_title_maxlength
        }
      },

      errorPlacement: function(){},

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

            $(form).find('input').removeAttr('disabled');
            $(form).resetForm();

            _this.jotBarWriteMore({}, 'hide');
            //_this.jotBarClip({}, 'hide');
            //_this.jotBarLocation({}, 'hide');
            _this.jotBarTag({}, 'hide');
            _this.setButtonAnimation({}, 'hide');
            _this.needResetAfterSubmit();
          },
          beforeSend: function(jqXHR, settings){
            $(form).find('input').attr({
              disabled: 'disabled'
            });
          }
        });

        return false;
      }
    });
    
    $('#jot-form-title-field').bind('keyup', function(){
      $(_this.current_length_holder).text(_this.jot_title_maxlength - this.value.length);
    });
  },

  open: function(){
    $(this.options.el).removeClass('hidden');
    this.middleView.openJot();

    this.jots.more({
      timestamp: 'now'
    });
  },

  item: function(jots, reverse){
    this.listView = new ListView({
      model: jots
    });
    this.listView.setElement('#main-middle-jot-list')
    this.listView.openJot(reverse);
  },

  addItem: function(jots){
    this.item(jots, true)
  },

  renderItem: function(jots, reverse){
    
  },

  resetItem: function(){
    var _this = this;
   
    this.jots.each(function(data){
      _this.item(data);
    });
  },

  xhrMagicField: null,

  keywordMagicField: null,

  renderMagicField: function(){
    var _this = this;

    $('#jot-form-title-field').bind('keyup', function(){
      var regex_f = new RegExp(/\/[F|f]\/(\S*)/);
      var regex_f_data = regex_f.exec(this.value);

      if(regex_f_data && regex_f_data[1] && _this.keywordMagicField != regex_f_data[1]){
        
        if(_this.xhrMagicField){
          _this.xhrMagicField.abort();
        }

        _this.keywordMagicField = regex_f_data[1];
        
        _this.xhrMagicField = _this.connections.fetch({
          data: {
            provider: 'facebook',
            allowed: true,
            keyword: _this.keywordMagicField
          },
          beforeSend: function(){
          },
          success: function(data, textStatus, jqXHR){
            alert(JSON.stringify(data));
          },
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          }
        });
      }
      else if(/(\/T)|(\/t)/.test(this.value)){
        
    }
    });
  },

  events:{
    'click #jot-bar-write-more': 'jotBarWriteMore',
    
    'click #jot-bar-clip': 'jotBarClip',

    'click #jot-bar-location': 'jotBarLocation',

    'click #jot-bar-tag': 'jotBarTag',

    'click #link-to-open-all-more-input': 'jotAllTag'
  },

  jotBarWriteMore: function(e, force){
    var _this = this;
    
    if(force == 'show'){
      $('#jot-write-more-panel').removeClass('hidden');
      $('#jot-write-more-field').rules("add", {
        required: true,
        maxlength: _this.jot_more_maxlength
      });
      
      $('#jot-write-more-field').bind('keyup', function(){
        $(_this.current_more_length_holder).text(_this.jot_more_maxlength - this.value.length);
      });
    }
    else if(force == 'hide'){
      $('#jot-write-more-panel').addClass('hidden');
      $('#jot-write-more-field').rules("remove");
    }
    else{
      $('#jot-write-more-panel').toggleClass( function(index, current_class_name){

        if(/hidden/.test(current_class_name)){
          $('#jot-write-more-field').rules("add", {
            required: true,
            maxlength: 512
          });

          $('#jot-write-more-field').bind('keyup', function(){
            $(_this.current_more_length_holder).text(_this.jot_more_maxlength - this.value.length);
          });
        }
        else{
          $('#jot-write-more-field').rules("remove");
        }

        return 'hidden';
      });
    }
  },

  jotBarClip: function(e, force){

    if(force == 'show'){
      $('#jot-clip-panel').removeClass('hidden');
    }
    else if(force == 'hide'){
      $('#jot-clip-panel').addClass('hidden');
    }
    else{
      $('#jot-clip-panel').toggleClass('hidden');
    }
  },

  jotBarLocation: function(e, force){
    
    if(force == 'show'){
      $('#jot-location-panel').removeClass('hidden');
    }
    else if(force == 'hide'){
      $('#jot-location-panel').addClass('hidden');
    }
    else{
      $('#jot-location-panel').toggleClass('hidden');
    }
  },

  jotBarTag: function(e, force){
    var _this = this;
    if(force == 'show'){
      _this.resetListJotTag([]);
      $('#jot-tag-more').removeClass('hidden');
    }
    else if(force == 'hide'){
      $('#jot-tag-more').addClass('hidden');
    }
    else{

      $('#jot-tag-more').toggleClass(function(index, current_class_name){

        if(/hidden/.test(current_class_name)){
          _this.resetListJotTag([]);
        }

        return 'hidden';
      })
    }
  },

  setButtonAnimation: function(e, force){
    var buttons = $(this.el).find('.jot-bar-button');

    if(force == 'show'){
      buttons.each(function(){
        $(this).addClass('jot_click jot_click_active');
      });
    }
    else if(force == 'hide'){
      buttons.each(function(){
        $(this).removeClass('jot_click jot_click_active');
      });
    }
    else{
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
    }

    
  },

  setClipField: function(){
    this.currentUserModel = new CurrentUserModel;

    this.uploadedClips = new UploadedClipCollection;
    this.uploadedClips.bind('add', this.addListUploadedClip, this);

    var _this = this;

    $('#jot-clip-field').setUploadify({
      auto: true,
      multi: true,
      script: '/clips.json',
      onComplete: function(event, queueID, fileObj, response, data) {

        var obj_response = JSON.parse(response);
   
        if(obj_response.failed === true){
          alert(obj_response.error)
        }
        else{
          _this.uploadedClips.add(obj_response.content);
        }
      }
    }, {
      token: this.currentUserModel.token()
    });
  },

  addListUploadedClip: function(data){
    this.listUploadedClip(data, true);
  },

  listUploadedClip: function(data, reverse){
    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#list-uploaded-clip-holder');
    this.listView.openUploadedClip(reverse);
  },

  jot_all_tag_is_open: null,

  jotAllTag: function(e){

    if(this.jot_all_tag_is_open){
      this.jotBarWriteMore(e, 'hide');
      //this.jotBarClip(e, 'hide');
      //this.jotBarLocation(e, 'hide');
      this.jotBarTag(e, 'hide');
      this.setButtonAnimation(e, 'hide');

      $('#link-to-open-all-more-input').removeClass('jot_up_arrow');

      this.jot_all_tag_is_open = null;
    }
    else{
      this.jotBarWriteMore(e, 'show');
      //this.jotBarClip(e, 'show');
      //this.jotBarLocation(e, 'show');
      this.jotBarTag(e, 'show');
      this.setButtonAnimation(e, 'show');

      $('#link-to-open-all-more-input').addClass('jot_up_arrow');

      this.jot_all_tag_is_open = 1;
    }
  },
  setJotTagField: function(e){
    var _this = this;

    $('#jot-form-title-field').on('propertychange input paste reset', function(event){

      if (($(this)).val().match(/#\w+/)){

        _this.jotBarTag(e, 'show');
        $('#jot-bar-tag').addClass('jot_click_active jot_click');

      } else {

        _this.jotBarTag(e, 'hide');
        $('#jot-bar-tag').removeClass('jot_click_active jot_click');

      }

      var text_array = new Array();

      _.each($(this).val().match(/#\w+\s*/gi), function(data){
        text_array.push(data.slice(1, data.length));
      });

      _this.resetListJotTag(text_array);
    });
  },

  resetListJotTag: function(data){
    var _this = this;

    $('#list-jot-tag-holder').html('');
    _.each(data, function(jot_tag) {
      _this.listJotTag({
        name: jot_tag
      }, false);
    });
  },

  listJotTag: function(data, reverse){
    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#list-jot-tag-holder');
    this.listView.openJotTag(reverse);
  }
})
