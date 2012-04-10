window.MagicboxJotView = Backbone.View.extend({

  default_options: {
    elNav: '',
    el: ''
  },

  initialize: function(options){
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
  },

  validates: function(){
    var _this = this;

    this.validates = $('#jots-form').validate({
      rules: {
        'jot[title]': {
          required: true
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
          }
        });

        return false;
      }
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

    'click #jot-bar-tag': 'jotBarTag'
  },

  jotBarWriteMore: function(){
    $('#jot-write-more-panel').toggleClass( function(index, current_class_name){
      
      if(/hidden/.test(current_class_name)){
        $('#jot-write-more-field').rules("add", {
          required: true,
          maxlength: 512
        });
      }
      else{
        $('#jot-write-more-field').rules("remove");
      }
      
      return 'hidden';
    });
  },

  jotBarClip: function(){
    $('#jot-clip-panel').toggleClass('hidden');
  },

  jotBarLocation: function(){
    $('#jot-location-panel').toggleClass('hidden');
  },

  jotBarTag: function(){
    $('#jot-tag-more').toggleClass('hidden');
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
    }, {token: this.currentUserModel.token()});
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

  setJotTagField: function(){
    var _this = this;

    $('#jot-form-title-field').on('propertychange input paste', function(event){

        if (($(this)).val().match(/#\w+/)){

          $('#jot-tag-more').removeClass('hidden');

          var text_array = new Array();

          _.each($(this).val().match(/#\w+\s*/gi), function(data){
            text_array.push(data.slice(1, data.length));
          });

          _this.resetListJotTag(text_array);

        }
    });
  },

  resetListJotTag: function(data){
    var _this = this;

    $('#list-jot-tag-holder').html('');
    _.each(data, function(jot_tag) {
      _this.listJotTag({ name: jot_tag }, false);
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
