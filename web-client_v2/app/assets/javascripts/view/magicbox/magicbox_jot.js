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
  },

  validates: function(){
    var _this = this;

    $('#jots-form').validate({
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
  }
})