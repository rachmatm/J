window.MiddleNestTemplate = Backbone.View.extend({

  template: _.template($('#nest-template').html()),

  initialize: function(){
    this.nests = new NestCollection;
    this.nests.bind('add', this.addItem, this);
    this.nests.bind('all', this.renderItem, this);
    this.nests.bind('reset', this.resetItem, this);
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template());

    this.nests.fetch();

    this.addGroupFromEl = $('#nest-group-form');

    $(this.addGroupFromEl).validate({
      rules: {
        'nest[group_name]': {
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
              _this.nests.add(data.content);
              $.colorbox.close();
            }
          }
        });

        return false;
      }
    });

    $('.add-group-popup-submit').bind('click', function(){
      $(_this.addGroupFromEl).trigger('submit');
    });
  },

  events: {
    'click .link-to-add-group': 'addGroup'
  },

  addGroup: function(){
    $.colorbox({
      href:'#add-group-popup',
      inline:true,
      overlayClose: false
    });
  },

  addItem: function(data){

    this.item(data, true);
  },

  renderItem: function(){
    
  },

  resetItem: function(){
    var _this = this;

    this.nests.each(function(data){
      _this.item(data);
    });
  },

  item: function(data, reverse){

    this.listView = new ListView({
      model: data
    });

    this.listView.setElement('#nest-list');
    this.listView.openNest(reverse);
  }
});