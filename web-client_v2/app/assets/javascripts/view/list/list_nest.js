window.ListNestView = Backbone.View.extend({

  template : _.template($('#list-nest-template').html()),

  initialize: function(){
    this.data = this.model.toJSON();

    this.magicboxSearchNestView = new MagicboxSearchNestView({model: this.model});
  },

  render: function(){
    var _this = this;

    $(this.el).html(this.template( this.data ));

    this.updateFormEl = $('#this-nest-rename-' + this.data._id + '-form');

    $(this.updateFormEl).validate({
      rules: {
        'nest[name]': {
          required: true
        }
      },

      errorPlacement: function(){},

      submitHandler: function(form){
        
        $(form).ajaxSubmit({
          type: 'get',
          error: function(jqXHR, textStatus, errorThrown){
            alert(textStatus);
          },
          success: function(data, textStatus, jqXHR){
            if(data.failed === true){
              alert(data.error);
            }
            else{
              _this.model.set(data.content);
              _this.render();
              $.colorbox.close();
            }
          }
        });

        return false;
      }
    });

    $('.this-nest-rename-submit-' +  this.data._id).bind('click', function(){
      $(_this.updateFormEl).trigger('submit');
    });

    this.nest_items = new NestItemCollection(this.data._id);
    this.nest_items.bind('reset', this.resetItem, this);

    this.nest_items.fetch();
  },

  events: {
    'click .link-to-delete': 'destroy',
    'click .link-to-rename': 'rename',
    'click .link-to-search': 'search'
  },

  destroy: function(){
    var _this = this;

    var action_confirmation = confirm('are you sure?')

    if(!action_confirmation){return false;}

    this.model.destroy({
      error: function(jqXHR, textStatus, errorThrown){
        alert(textStatus);
      },
      success: function(data, textStatus, jqXHR){
        if(data.failed === true){
          alert(data.error);
        }
        else{
          $(_this.el).remove();
        }
      }
    });
  },

  rename: function(){
    $.colorbox({
      href:'#rename-nest-' + this.data._id,
      inline:true,
      overlayClose: false
    });
  },

  search: function(){
    this.magicboxSearchNestView.setElement('#magicbox-search-options');
    this.magicboxSearchNestView.open();
  },

  resetItem: function(){
    
  }
})
