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

    this.middleView = new MiddleView({model: this.jots});
    this.middleView.setElement('#main-middle');

    this.validates();
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
  }
})